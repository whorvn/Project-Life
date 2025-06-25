import 'package:flutter/material.dart';
import '../models/hackathon.dart';
import '../services/api_service.dart';

class HackathonProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Hackathon> _hackathons = [];
  Hackathon? _currentHackathon;
  bool _isLoading = false;
  String? _error;

  List<Hackathon> get hackathons => _hackathons;
  Hackathon? get currentHackathon => _currentHackathon;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> loadHackathons() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final hackathons = await _apiService.getHackathons();
      _hackathons = hackathons;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load hackathons: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<Hackathon?> getHackathon(String id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final hackathon = await _apiService.getHackathon(id);
      _currentHackathon = hackathon;
      notifyListeners();
      return hackathon;
    } catch (e) {
      _setError('Failed to load hackathon: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Hackathon?> createHackathon(Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final hackathon = await _apiService.createHackathon(data);
      _hackathons.add(hackathon);
      _currentHackathon = hackathon;
      notifyListeners();
      return hackathon;
    } catch (e) {
      _setError('Failed to create hackathon: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<Hackathon?> updateHackathon(String id, Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final hackathon = await _apiService.updateHackathon(id, data);
      final index = _hackathons.indexWhere((h) => h.id == id);
      if (index != -1) {
        _hackathons[index] = hackathon;
      }
      if (_currentHackathon?.id == id) {
        _currentHackathon = hackathon;
      }
      notifyListeners();
      return hackathon;
    } catch (e) {
      _setError('Failed to update hackathon: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteHackathon(String id) async {
    _setLoading(true);
    _setError(null);
    
    try {
      await _apiService.deleteHackathon(id);
      _hackathons.removeWhere((h) => h.id == id);
      if (_currentHackathon?.id == id) {
        _currentHackathon = null;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete hackathon: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>?> getPublicHackathonData(String id) async {
    try {
      return await _apiService.getPublicHackathonData(id);
    } catch (e) {
      _setError('Failed to load public hackathon data: ${e.toString()}');
      return null;
    }
  }

  void clearError() {
    _setError(null);
  }

  void setCurrentHackathon(Hackathon? hackathon) {
    _currentHackathon = hackathon;
    notifyListeners();
  }
}
