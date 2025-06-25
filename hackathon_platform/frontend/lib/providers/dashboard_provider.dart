import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;

  int get selectedIndex => _selectedIndex;
  bool get isDrawerOpen => _isDrawerOpen;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void setDrawerOpen(bool open) {
    _isDrawerOpen = open;
    notifyListeners();
  }

  // Dashboard navigation items
  List<DashboardNavItem> get navigationItems => [
    DashboardNavItem(
      icon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    DashboardNavItem(
      icon: Icons.event,
      label: 'Hackathons',
      route: '/hackathons',
    ),
    DashboardNavItem(
      icon: Icons.group,
      label: 'Teams',
      route: '/teams',
    ),
    DashboardNavItem(
      icon: Icons.assignment,
      label: 'Submissions',
      route: '/submissions',
    ),
    DashboardNavItem(
      icon: Icons.school,
      label: 'Mentorship',
      route: '/mentorship',
    ),
    DashboardNavItem(
      icon: Icons.analytics,
      label: 'Analytics',
      route: '/analytics',
    ),
    DashboardNavItem(
      icon: Icons.settings,
      label: 'Settings',
      route: '/settings',
    ),
  ];
}

class DashboardNavItem {
  final IconData icon;
  final String label;
  final String route;

  DashboardNavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
