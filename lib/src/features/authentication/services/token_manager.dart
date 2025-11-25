// dart
import 'package:get_storage/get_storage.dart';
import 'package:loginappv2/src/utils/get_storage_key.dart';

class TokenManager {
  static final TokenManager _inst = TokenManager._internal();
  factory TokenManager() => _inst;
  TokenManager._internal();

  final GetStorage _storage = GetStorage();

  Future<void> saveAccessToken(String token) async {
    await _storage.write(GetStorageKey.accessToken, token);
  }

  Future<String?> getAccessToken() async {
    // explicit async/await to avoid returning a Future<Future>
    final token = await _storage.read(GetStorageKey.accessToken) as String?;
    return token;
  }

  Future<void> clearAccessToken() async {
    await _storage.remove(GetStorageKey.accessToken);
  }
}
