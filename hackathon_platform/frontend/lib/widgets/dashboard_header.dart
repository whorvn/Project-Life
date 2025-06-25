import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Page title
            Expanded(
              child: Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, child) {
                  final currentItem = dashboardProvider.navigationItems[
                      dashboardProvider.selectedIndex];
                  
                  return Text(
                    currentItem.label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            // Actions
            Row(
              children: [
                // Theme toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return IconButton(
                      onPressed: themeProvider.toggleTheme,
                      icon: Icon(
                        themeProvider.isDarkMode 
                            ? Icons.light_mode 
                            : Icons.dark_mode,
                      ),
                      tooltip: themeProvider.isDarkMode 
                          ? 'Switch to light mode' 
                          : 'Switch to dark mode',
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Notifications
                IconButton(
                  onPressed: () {
                    // TODO: Implement notifications
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifications coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 8),
                // Help
                IconButton(
                  onPressed: () {
                    // TODO: Implement help
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help documentation coming soon!'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.help_outline),
                  tooltip: 'Help',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
