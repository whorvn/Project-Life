import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/hackathon_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_header.dart';
import 'hackathons_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HackathonProvider>(context, listen: false).loadHackathons();
    });
  }

  Widget _buildMainContent(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const DashboardOverview();
      case 1:
        return const HackathonsScreen();
      case 2:
        return const NotImplementedScreen(title: 'Teams');
      case 3:
        return const NotImplementedScreen(title: 'Submissions');
      case 4:
        return const NotImplementedScreen(title: 'Mentorship');
      case 5:
        return const NotImplementedScreen(title: 'Analytics');
      case 6:
        return const NotImplementedScreen(title: 'Settings');
      default:
        return const DashboardOverview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        return Scaffold(
          body: Row(
            children: [
              // Sidebar
              const DashboardSidebar(),
              // Main content
              Expanded(
                child: Column(
                  children: [
                    const DashboardHeader(),
                    Expanded(
                      child: _buildMainContent(dashboardProvider.selectedIndex),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonProvider>(
      builder: (context, hackathonProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildStatCard(
                      context,
                      'Total Hackathons',
                      '${hackathonProvider.hackathons.length}',
                      Icons.event,
                      Colors.blue,
                    ),
                    _buildStatCard(
                      context,
                      'Active Events',
                      '${hackathonProvider.hackathons.where((h) => h.status == 'active').length}',
                      Icons.play_circle,
                      Colors.green,
                    ),
                    _buildStatCard(
                      context,
                      'Upcoming Events',
                      '${hackathonProvider.hackathons.where((h) => h.status == 'upcoming').length}',
                      Icons.schedule,
                      Colors.orange,
                    ),
                    _buildStatCard(
                      context,
                      'Past Events',
                      '${hackathonProvider.hackathons.where((h) => h.status == 'completed').length}',
                      Icons.check_circle,
                      Colors.grey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class NotImplementedScreen extends StatelessWidget {
  final String title;

  const NotImplementedScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            '$title Coming Soon',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is under development',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
