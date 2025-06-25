import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/hackathon.dart';
import '../config/app_config.dart';

class HackathonProvider with ChangeNotifier {
  List<Hackathon> _hackathons = [];
  List<Hackathon> _myHackathons = [];
  Hackathon? _currentHackathon;
  bool _isLoading = false;
  String? _error;

  List<Hackathon> get hackathons => _hackathons;
  List<Hackathon> get myHackathons => _myHackathons;
  Hackathon? get currentHackathon => _currentHackathon;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> fetchHackathons() async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _hackathons = data.map((json) => Hackathon.fromJson(json)).toList();
      } else {
        setError('Failed to fetch hackathons');
      }
    } catch (e) {
      setError('Network error: $e');
    }

    setLoading(false);
  }

  Future<void> fetchMyHackathons(String token) async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/my'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _myHackathons = data.map((json) => Hackathon.fromJson(json)).toList();
      } else {
        setError('Failed to fetch my hackathons');
      }
    } catch (e) {
      setError('Network error: $e');
    }

    setLoading(false);
  }

  Future<Hackathon?> createHackathon(Map<String, dynamic> hackathonData, String token) async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(hackathonData),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final hackathon = Hackathon.fromJson(data);
        _myHackathons.add(hackathon);
        _hackathons.add(hackathon);
        notifyListeners();
        return hackathon;
      } else {
        setError('Failed to create hackathon');
        return null;
      }
    } catch (e) {
      setError('Network error: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchHackathon(String id) async {
    setLoading(true);
    setError(null);

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentHackathon = Hackathon.fromJson(data);
      } else {
        setError('Failed to fetch hackathon');
      }
    } catch (e) {
      setError('Network error: $e');
    }

    setLoading(false);
  }

  Future<Map<String, dynamic>?> getHackathonLandingPageData(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/hackathons/$id/landing-page'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      setError('Network error: $e');
      return null;
    }
  }

  void clearCurrentHackathon() {
    _currentHackathon = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
