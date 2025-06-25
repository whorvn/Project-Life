import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/hackathon.dart';
import '../models/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<T> _handleRequest<T>(
    Future<http.Response> request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request;
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return fromJson(data);
      } else {
        throw ApiException(
          message: data['detail'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on FormatException {
      throw ApiException(message: 'Invalid response format');
    }
  }

  Future<List<T>> _handleListRequest<T>(
    Future<http.Response> request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request;
      final data = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (data is List) {
          return data.map((item) => fromJson(item)).toList();
        }
        throw ApiException(message: 'Expected list response');
      } else {
        throw ApiException(
          message: data['detail'] ?? 'Request failed',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw ApiException(message: 'No internet connection');
    } on FormatException {
      throw ApiException(message: 'Invalid response format');
    }
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    return _handleRequest(
      http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/login'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
        }),
      ),
      (data) => data,
    );
  }

  Future<User> register(String email, String password, String fullName) async {
    return _handleRequest(
      http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/register'),
        headers: _headers,
        body: json.encode({
          'email': email,
          'password': password,
          'full_name': fullName,
        }),
      ),
      (data) => User.fromJson(data),
    );
  }

  Future<User> getCurrentUser() async {
    return _handleRequest(
      http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/me'),
        headers: _headers,
      ),
      (data) => User.fromJson(data),
    );
  }

  // Hackathon endpoints
  Future<List<Hackathon>> getHackathons() async {
    return _handleListRequest(
      http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/'),
        headers: _headers,
      ),
      (data) => Hackathon.fromJson(data),
    );
  }

  Future<Hackathon> getHackathon(String id) async {
    return _handleRequest(
      http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id'),
        headers: _headers,
      ),
      (data) => Hackathon.fromJson(data),
    );
  }

  Future<Hackathon> createHackathon(Map<String, dynamic> data) async {
    return _handleRequest(
      http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/'),
        headers: _headers,
        body: json.encode(data),
      ),
      (data) => Hackathon.fromJson(data),
    );
  }

  Future<Hackathon> updateHackathon(String id, Map<String, dynamic> data) async {
    return _handleRequest(
      http.put(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id'),
        headers: _headers,
        body: json.encode(data),
      ),
      (data) => Hackathon.fromJson(data),
    );
  }

  Future<void> deleteHackathon(String id) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id'),
      headers: _headers,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final data = json.decode(response.body);
      throw ApiException(
        message: data['detail'] ?? 'Failed to delete hackathon',
        statusCode: response.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> getPublicHackathonData(String id) async {
    return _handleRequest(
      http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id/public'),
        headers: {'Content-Type': 'application/json'},
      ),
      (data) => data,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}
