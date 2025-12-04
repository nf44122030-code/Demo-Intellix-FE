import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String _userEmail = '';
  String _userName = 'John Doe';

  bool get isAuthenticated => _isAuthenticated;
  String get userEmail => _userEmail;
  String get userName => _userName;

  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userEmail = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userEmail = email;
      _userName = name;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    _userEmail = '';
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
  }
}
