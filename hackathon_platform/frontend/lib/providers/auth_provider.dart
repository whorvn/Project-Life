import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  String? _token;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null && _token != null;
  String? get token => _token;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('AuthProvider: Starting login for $email');
      final response = await _apiService.login(email, password);
      print('AuthProvider: Login response received: ${response.keys}');
      
      _token = response['access_token'];
      _user = User.fromJson(response['user']);
      
      print('AuthProvider: Token set, user: ${_user?.fullName}');
      
      // Set token for future API calls
      _apiService.setToken(_token!);
      
      _isLoading = false;
      notifyListeners();
      print('AuthProvider: Login successful');
      return true;
    } catch (e) {
      print('AuthProvider: Login error: $e');
      _isLoading = false;
      notifyListeners();
      rethrow; // Re-throw the exception so the UI can show it
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _apiService.register(email, password, fullName);
      // After registration, automatically login
      return await login(email, password);
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkAuthStatus() async {
    // TODO: Implement token storage and retrieval
    // For now, just simulate a delay
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _apiService.setToken(null);
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    if (_token != null) {
      try {
        _user = await _apiService.getCurrentUser();
        notifyListeners();
      } catch (e) {
        // Token might be invalid, logout
        await logout();
      }
    }
  }
}
