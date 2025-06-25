import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isLoading = false;
  String? _token;
  bool _isInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null && _token != null;
  String? get token => _token;
  bool get isInitialized => _isInitialized;

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  // Initialize auth state from storage
  Future<void> initializeAuth() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final userJson = prefs.getString(_userKey);

      if (token != null && userJson != null) {
        _token = token;
        _user = User.fromJson(json.decode(userJson));
        _apiService.setToken(_token!);
        
        // Verify token is still valid
        try {
          await _apiService.getCurrentUser();
        } catch (e) {
          // Token invalid, clear stored data
          await _clearStoredAuth();
        }
      }
    } catch (e) {
      print('Error initializing auth: $e');
      await _clearStoredAuth();
    } finally {
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveAuthData() async {
    if (_token != null && _user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _token!);
      await prefs.setString(_userKey, json.encode(_user!.toJson()));
    }
  }

  Future<void> _clearStoredAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    _token = null;
    _user = null;
    _apiService.setToken(null);
  }

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
      
      // Save auth data to persistent storage
      await _saveAuthData();
      
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
    if (!_isInitialized) {
      await initializeAuth();
    }
  }

  Future<void> logout() async {
    await _clearStoredAuth();
    notifyListeners();
  }

  Future<void> loadCurrentUser() async {
    if (_token != null) {
      try {
        _user = await _apiService.getCurrentUser();
        await _saveAuthData(); // Update stored user data
        notifyListeners();
      } catch (e) {
        // Token might be invalid, logout
        await logout();
      }
    }
  }
}
