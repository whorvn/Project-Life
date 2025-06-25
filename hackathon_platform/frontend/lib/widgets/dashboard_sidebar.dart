import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo section
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.code,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'HackPlatform',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          // Navigation items
          Expanded(
            child: Consumer<DashboardProvider>(
              builder: (context, dashboardProvider, child) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: dashboardProvider.navigationItems.length,
                  itemBuilder: (context, index) {
                    final item = dashboardProvider.navigationItems[index];
                    final isSelected = dashboardProvider.selectedIndex == index;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListTile(
                        leading: Icon(
                          item.icon,
                          color: isSelected 
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        title: Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onTap: () {
                          dashboardProvider.setSelectedIndex(index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          // User section
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          authProvider.user?.fullName.substring(0, 1).toUpperCase() ?? 'U',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        authProvider.user?.fullName ?? 'User',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        authProvider.user?.email ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed('/login');
                          }
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Sign Out'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
