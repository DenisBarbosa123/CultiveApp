import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenUtil {
// Create storage
  final _storage = new FlutterSecureStorage();

  void saveToken(String bearerToken) async {
    _storage.write(
        key: "jwt", value: bearerToken.replaceFirst("Bearer", "").trim());
  }

  Future<String> getToken() async {
    String token = await _storage.read(key: "jwt");
    return "Bearer " + token;
  }

  void deleteToken() {
    _storage.delete(key: "jwt");
  }
}
