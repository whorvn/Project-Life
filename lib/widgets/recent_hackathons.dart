import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../config/theme_config.dart';
import '../widgets/hackathon_card.dart';

class RecentHackathons extends StatelessWidget {
  const RecentHackathons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Hackathons',
              style: ThemeConfig.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hackathons/all');
              },
              child: Text(
                'View All',
                style: ThemeConfig.bodyMedium.copyWith(
                  color: ThemeConfig.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<HackathonProvider>(
          builder: (context, hackathonProvider, child) {
            if (hackathonProvider.isLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (hackathonProvider.error != null) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hackathonProvider.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }

            final recentHackathons = hackathonProvider.hackathons.take(3).toList();

            if (recentHackathons.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.code_off,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hackathons yet',
                      style: ThemeConfig.bodyLarge.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to create one!',
                      style: ThemeConfig.bodyMedium.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/hackathon/create');
                      },
                      child: const Text('Create Hackathon'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: recentHackathons
                  .map((hackathon) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: HackathonCard(hackathon: hackathon),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
