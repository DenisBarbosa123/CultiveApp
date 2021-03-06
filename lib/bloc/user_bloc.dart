import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/user_auth.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/notification/push_notification_configure.dart';
import 'package:cultiveapp/utils/path_constants.dart';
import 'package:cultiveapp/utils/token_util.dart';
import 'package:cultiveapp/utils/json_store_util.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class UserBloc extends BlocBase {
  //Token util
  final _tokenUtil = TokenUtil();
  //JsonStoreUtil
  JsonStoreUtil _jsonStoreUtil = JsonStoreUtil();
  //user information map
  Map<String, dynamic> userInformation = Map<String, dynamic>();

  PushNotificationConfigure _pushNotificationConfigure =
      PushNotificationConfigure();

  final _loginController = StreamController<AuthenticationStatus>.broadcast();
  Stream get loginOutput => _loginController.stream;

  final _userInformationController =
      StreamController<Map<String, dynamic>>.broadcast();
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
        subscribeTopics(user.topicos);
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
      String token,
      VoidCallback onSuccess,
      VoidCallback onInvalidEmail,
      VoidCallback onTokenNotFound,
      VoidCallback onTokenExpired,
      VoidCallback onFail}) async {
    try {
      debugPrint("Reset password in progress...");
      UserAuth userAuth =
          UserAuth(password: newPassword, username: username, token: token);
      Response response = await Dio().put(PathConstants.resetUserPasswordUrl(),
          data: json.encode(userAuth.toJson()));
      if (response.statusCode == 200) {
        debugPrint("Reset password is successful...");
        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during Reset password..." + e.toString());
      String erro = e.toString();
      if (erro.contains("404")) {
        onInvalidEmail();
      } else if (erro.contains("400")) {
        onTokenNotFound();
      } else if (erro.contains("403")) {
        onTokenExpired();
      } else {
        onFail();
      }
    }
  }

  void _saveUserData(User user, String token) {
    userInformation["user"] = user;
    userInformation["token"] = token;
    _userInformationController.add(userInformation);
    _jsonStoreUtil.saveJson("user", user.toJson());
    _tokenUtil.saveToken(token);
  }

  Future<void> editUser(
      {User user,
      int userId,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    try {
      debugPrint("User update performing....");
      String token = await _tokenUtil.getToken();
      Response response = await Dio().put(
          PathConstants.editUserById(userId.toString()),
          data: json.encode(user.toJson()),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 200) {
        debugPrint("User update successfully....");
        User userUpdated = User.fromJson(response.data);
        userInformation["user"] = userUpdated;
        _userInformationController.add(userInformation);
        _jsonStoreUtil.saveJson("user", userUpdated.toJson());
        onSuccess();
      } else {
        debugPrint("Fail during user update");
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during user update");
      onFail();
    }
  }

  Future<void> deleteUser(
      {User user, VoidCallback onSuccess, VoidCallback onFail}) async {
    try {
      debugPrint("User exclusion performing....");
      deleteProfilePhoto(user.fotoPerfil);
      unSubscribeTopics(user.topicos);
      String token = await _tokenUtil.getToken();
      Response response = await Dio().delete(
          PathConstants.deleteUserById(user.id.toString()),
          options: RequestOptions(headers: {"Authorization": token}));
      if (response.statusCode == 204) {
        _loginController.add(AuthenticationStatus.unauthenticated);
        userInformation.clear();
        _tokenUtil.deleteToken();
        _jsonStoreUtil.deleteJsonByKey("user");
        onSuccess();
        debugPrint("User exclusion successfully....");
      }
    } catch (e) {
      debugPrint("Exception during user exclusion");
      onFail();
    }
  }

  Future<void> requestUpdatePassword(
      {VoidCallback onSuccess, VoidCallback onFail, String email}) async {
    debugPrint("Request update password performing");
    UserAuth auth = UserAuth(username: email);
    try {
      Response response = await Dio()
          .post(PathConstants.requestUpdatePassword(), data: auth.toJson());
      if (response.statusCode == 202) {
        debugPrint("Request update password successfully");
        onSuccess();
      } else {
        debugPrint("Request update password fail");
        onFail();
      }
    } catch (e) {
      debugPrint("Exception during Request password");
      onFail();
    }
  }

  void logout() {
    debugPrint("Logout is performing...");
    _loginController.add(AuthenticationStatus.unauthenticated);
    userInformation.clear();
    _tokenUtil.deleteToken();
    _jsonStoreUtil.deleteJsonByKey("user");
    debugPrint("Logout successful...");
  }

  Future<void> loadCurrentUser() async {
    if (userInformation.isEmpty) {
      debugPrint("Loading current user in progress...");
      userInformation["token"] = await _tokenUtil.getToken();
      Map<String, dynamic> userJson = await _jsonStoreUtil.getJsonByKey("user");
      userJson != null
          ? userInformation["user"] = User.fromJson(userJson)
          : userInformation["user"] = null;
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

  Future<void> deleteProfilePhoto(String pathProfilePhoto) async {
    if (pathProfilePhoto == null) {
      return;
    }

    StorageReference storageReference = await FirebaseStorage.instance
        .ref()
        .getStorage()
        .getReferenceFromUrl(pathProfilePhoto);
    storageReference.delete().then((value) => print("deleted profile photo"));
  }

  void subscribeTopics(List<Topicos> topicList) {
    _pushNotificationConfigure.subscribeTopics(topicList);
  }

  void unSubscribeTopics(List<Topicos> topicList) {
    _pushNotificationConfigure.unSubscribeTopics(topicList);
  }

  @override
  void dispose() {
    super.dispose();
    _loginController.close();
    _userInformationController.close();
  }
}
