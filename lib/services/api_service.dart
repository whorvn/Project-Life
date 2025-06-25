import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/hackathon.dart';
import '../config/app_config.dart';

class ApiService {
  static const String baseUrl = AppConfig.apiBaseUrl;

  // Auth endpoints
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  static Future<User?> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  static Future<User?> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  // Hackathon endpoints
  static Future<List<Hackathon>> getHackathons() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hackathons'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Hackathon.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch hackathons: $e');
    }
  }

  static Future<List<Hackathon>> getMyHackathons(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hackathons/my'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Hackathon.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch my hackathons: $e');
    }
  }

  static Future<Hackathon?> getHackathon(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hackathons/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Hackathon.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch hackathon: $e');
    }
  }

  static Future<Hackathon?> createHackathon(Map<String, dynamic> hackathonData, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/hackathons'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(hackathonData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Hackathon.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create hackathon: $e');
    }
  }

  static Future<Hackathon?> updateHackathon(String id, Map<String, dynamic> hackathonData, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/hackathons/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(hackathonData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Hackathon.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to update hackathon: $e');
    }
  }

  static Future<bool> deleteHackathon(String id, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/hackathons/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 204;
    } catch (e) {
      throw Exception('Failed to delete hackathon: $e');
    }
  }

  static Future<Map<String, dynamic>?> getHackathonLandingPageData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hackathons/$id/landing-page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch landing page data: $e');
    }
  }
}
