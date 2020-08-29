import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenUtil {
// Create storage
  final _storage = new FlutterSecureStorage();

  void saveToken(String bearerToken) async {
    String token = bearerToken.replaceFirst("Bearer", "").trim();
    debugPrint("saving token $token");
    _storage.write(key: "jwt", value: token);
  }

  Future<String> getToken() async {
    return await _storage.read(key: "jwt");
  }

  void deleteToken() {
    _storage.delete(key: "jwt");
  }
}
