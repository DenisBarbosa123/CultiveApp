import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/user_auth.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:cultiveapp/utils/token_util.dart';
import 'package:cultiveapp/utils/user_id_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class UserBloc extends BlocBase {
  //Token util
  final _tokenUtil = TokenUtil();
  //User Id Util
  UserIdUtil _userIdUtil = UserIdUtil();
  //user information map
  Map<String, dynamic> userInformation = Map<String, dynamic>();

  final _loginController = StreamController<AuthenticationStatus>();
  Stream get loginOutput => _loginController.stream;

  final _userInformationController = StreamController<Map<String, dynamic>>();
  Stream get userInformationOutput => _loginController.stream;

  Future<void> submitSubscription(
      {Map<String, dynamic> userPayload,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    try {
      debugPrint("Subscription in progress...");
      Response response = await Dio()
          .post(PathConstants.createUserUrl(), data: json.encode(userPayload));
      if (response.statusCode == 200) {
        debugPrint("Subscription successful...");
        onSuccess();
        User user = User.fromJson(userPayload);
        makeUserLogin(email: user.email, password: user.senha);
      } else
        onFail();
    } catch (e) {
      debugPrint("Subscription fail...");
      onFail();
    }
  }

  Future<void> makeUserLogin(
      {String email,
      String password,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    try {
      debugPrint("Login in progress...");
      UserAuth userAuth = UserAuth(
        username: email,
        password: password,
      );
      Response response = await Dio().post(PathConstants.userLoginUrl(),
          data: json.encode(userAuth.toJson()));
      if (response.statusCode == 202) {
        debugPrint("Login successful...");
        _loginController.add(AuthenticationStatus.authenticated);
        if (onSuccess != null) onSuccess();
        User user = User.fromJson(response.data);
        _saveUserData(user, response.headers.value("Authorization"));
      } else if (onFail != null) onFail();
    } catch (e) {
      debugPrint("Login fail...");
      onFail();
    }
  }

  Future<void> resetUserPassword(
      {String username,
      String newPassword,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    try {
      debugPrint("Reset password in progress...");
      UserAuth userAuth = UserAuth(password: newPassword, username: username);
      Response response = await Dio().put(PathConstants.resetUserPasswordUrl(),
          data: json.encode(userAuth.toJson()));
      if (response.statusCode == 200) {
        debugPrint("Reset password is successful...");
        makeUserLogin(email: username, password: newPassword);
        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      debugPrint("Reset password fail...");
      onFail();
    }
  }

  void _saveUserData(User user, String token) {
    userInformation["user"] = user;
    userInformation["token"] = token;
    _userInformationController.add(userInformation);
    _userIdUtil.saveUserId(user.id);
    _tokenUtil.saveToken(token);
  }

  void logout() {
    _loginController.add(AuthenticationStatus.unauthenticated);
    userInformation.clear();
    _tokenUtil.deleteToken();
    _userIdUtil.deleteUserId();
  }

  Future<void> loadCurrentUser() async {
    if (userInformation.isEmpty) {
      debugPrint("Loading current user in progress...");
      userInformation["token"] = await _tokenUtil.getToken();
      await getUserById(userInformation["token"]);
      if (userInformation["token"] != null && userInformation["user"] != null) {
        debugPrint("Loading current user successful...");
        _loginController.add(AuthenticationStatus.authenticated);
        _userInformationController.add(userInformation);
      } else {
        debugPrint("user not found...");
        _loginController.add(AuthenticationStatus.unauthenticated);
      }
    }
  }

  Future<void> getUserById(String token) async {
    String userId = await _userIdUtil.getUserId();
    debugPrint("Get user by id in progress...");
    debugPrint(userId);
    debugPrint(token);
    if (userId != null && token != null) {
      try {
        Response response = await Dio().get(PathConstants.getUserById(userId),
            options: RequestOptions(headers: {"Authorization": token}));
        if (response.statusCode == 200) {
          debugPrint("Get user by id is successful...");
          userInformation["user"] = User.fromJson(response.data);
        }
      } catch (e) {
        debugPrint("Get user by id is fail...");
      }
    }
  }

  @override
  void dispose() {
    _loginController.close();
    _userInformationController.close();
  }
}
