import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserIdUtil {
  // Create storage
  final _storage = new FlutterSecureStorage();

  void saveUserId(int userId) async {
    debugPrint("saving user id : $userId");
    _storage.write(key: "userId", value: userId.toString());
  }

  Future<String> getUserId() async {
    return await _storage.read(key: "userId");
  }

  void deleteUserId() {
    _storage.delete(key: "userId");
  }
}
