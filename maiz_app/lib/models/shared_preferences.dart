import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _googleUidKey = 'googleUid';
  static const String _userNameKey = 'userName';

  // Guardar token y userId (para usuarios normales)
   // Guardar sesión de usuario normal
  Future<void> saveUserSession({
    required String token,
    required String userId,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, name);
    await prefs.remove(_googleUidKey);
  }

  // Guardar sesión de usuario Google
  Future<void> saveGoogleSession({
    required String token,
    required String googleUid,
    required String userId,
    required String name,
    
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_googleUidKey, googleUid);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userIdKey, name);
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Obtener userId (si es usuario normal)
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Obtener googleUid (si es usuario de Google)
  Future<String?> getGoogleUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_googleUidKey);
  }

    // Obtener nombre del usuario
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Limpiar sesión
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_googleUidKey);
  }
}
