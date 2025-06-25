import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/hackathon_provider.dart';
import '../config/theme_config.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/recent_hackathons.dart';
import '../widgets/stats_overview.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      hackathonProvider.fetchHackathons();
      hackathonProvider.fetchMyHackathons(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: ThemeConfig.primaryColor,
                      child: Text(
                        authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      authProvider.user?.name ?? 'User',
                      style: ThemeConfig.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ThemeConfig.primaryColor, ThemeConfig.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: ThemeConfig.headlineMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to create or join amazing hackathons?',
                      style: ThemeConfig.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/hackathon/create');
                      },
                      icon: const Icon(Icons.add, color: ThemeConfig.primaryColor),
                      label: Text(
                        'Create Hackathon',
                        style: ThemeConfig.bodyLarge.copyWith(
                          color: ThemeConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats overview
              const StatsOverview(),
              const SizedBox(height: 24),

              // Quick actions
              Text(
                'Quick Actions',
                style: ThemeConfig.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'My Hackathons',
                      icon: Icons.code,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/hackathons/my');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DashboardCard(
                      title: 'All Hackathons',
                      icon: Icons.explore,
                      color: Colors.green,
                      onTap: () {
                        Navigator.pushNamed(context, '/hackathons/all');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Create Hackathon',
                      icon: Icons.add_circle,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.pushNamed(context, '/hackathon/create');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DashboardCard(
                      title: 'Analytics',
                      icon: Icons.analytics,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.pushNamed(context, '/not-implemented');
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent hackathons
              const RecentHackathons(),
            ],
          ),
        ),
      ),
    );
  }
}
