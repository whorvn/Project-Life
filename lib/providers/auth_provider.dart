import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _isInitialized = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  bool get isAuthenticated => _user != null && _token != null;

  final ApiService _apiService = ApiService();

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    // In a real app, check for stored token/user data
    await Future.delayed(const Duration(seconds: 1)); // Simulate initialization
    _isInitialized = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    
    try {
      final authToken = await _apiService.login(email, password);
      _user = authToken.user;
      _token = authToken.accessToken;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
