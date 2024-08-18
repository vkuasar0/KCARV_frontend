import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _jwt;
  String? _loginType;
  String? _email;

  String? get jwt => _jwt;
  String? get loginType => _loginType;
  String? get email => _email;

  AuthProvider() {
    _checkLoginStatus();
  }

  // Check if a user is logged in by checking JWT token in storage
  Future<void> _checkLoginStatus() async {
    String? token = await _storage.read(key: 'jwt');
    _jwt = token;
    token = await _storage.read(key: 'login_type');
    _loginType = token;
    token = await _storage.read(key: 'email');
    _email = token;
    notifyListeners(); // Notify listeners when login status changes
  }

  // Logout function to clear JWT and notify listeners
  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'login_type');
    await _storage.delete(key: 'email');
    _jwt = null;
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Method to simulate login and store JWT
  Future<void> login(String jwt, String type, String email) async {
    await _storage.write(key: 'jwt', value: jwt);
    _jwt = jwt;
    await _storage.write(key: 'login_type', value: type);
    _loginType = type;
    await _storage.write(key: 'email', value: email);
    _email = email;
    notifyListeners();
  }
}
