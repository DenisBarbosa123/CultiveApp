import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cultiveapp/model/user_auth.dart';
import 'package:cultiveapp/model/user_model.dart';
import 'package:cultiveapp/utils/token_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class UserBloc extends BlocBase {
  final _tokenUtil = TokenUtil();

  //UserStream
  StreamController<User> _userStream = StreamController<User>();
  Stream<User> get userOutput => _userStream.stream;

  String _createUserUrl() => "https://cultiveapp.herokuapp.com/api/usuario";
  String _userLoginUrl() =>
      "https://cultiveapp.herokuapp.com/api/usuario/login";
  String _resetUserPasswordUrl(String userId) =>
      "https://cultiveapp.herokuapp.com/api/usuario/$userId/senha";

  Future<void> submitSubscription(
      {Map<String, dynamic> userPayload,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    debugPrint("Subscription in progress...");
    Response response =
        await Dio().post(_createUserUrl(), data: json.encode(userPayload));
    if (response.statusCode == 200) {
      debugPrint("Subscription successful...");
      onSuccess();
      User user = User.fromJson(userPayload);
      makeUserLogin(email: user.email, password: user.senha);
    } else
      onFail();
  }

  Future<void> makeUserLogin(
      {String email,
      String password,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    debugPrint("Login in progress...");
    UserAuth userAuth = UserAuth(
      username: email,
      password: password,
    );
    Response response =
        await Dio().post(_userLoginUrl(), data: json.encode(userAuth.toJson()));
    if (response.statusCode == 202) {
      debugPrint("Login successful...");
      if (onSuccess != null) onSuccess();
      _tokenUtil.saveToken(response.headers.value("Authorization"));
      _userStream.sink.add(User.fromJson(response.data));
    } else if (onFail != null) onFail();
  }

  Future<void> resetUserPassword(
      {String userId,
      String newPassword,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    UserAuth userAuth = UserAuth(password: newPassword);
    Response response = await Dio().put(_resetUserPasswordUrl(userId),
        data: json.encode(userAuth.toJson()));
    if (response.statusCode == 200) {
      onSuccess();
    } else {
      onFail();
    }
  }

  void logout() {
    _tokenUtil.deleteToken();
  }

  @override
  void dispose() {
    _userStream.close();
  }
}
