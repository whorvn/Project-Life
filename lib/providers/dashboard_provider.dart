import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  Map<String, dynamic> _metrics = {};

  bool get isLoading => _isLoading;
  Map<String, dynamic> get metrics => _metrics;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    _metrics = {
      'totalHackathons': 25,
      'activeHackathons': 8,
      'totalParticipants': 1250,
      'totalTeams': 312,
    };
    
    _isLoading = false;
    notifyListeners();
  }
}
