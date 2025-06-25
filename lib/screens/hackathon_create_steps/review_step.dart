import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme_config.dart';
import '../../widgets/custom_button.dart';
import '../../providers/hackathon_provider.dart';

class ReviewStep extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onSubmit;
  final VoidCallback onPrevious;

  const ReviewStep({
    Key? key,
    required this.data,
    required this.onSubmit,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Submit',
            style: ThemeConfig.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review all the details before creating your hackathon.',
            style: ThemeConfig.bodyLarge.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information
                  _buildSection(
                    'Basic Information',
                    [
                      _buildInfoRow('Title', data['title']),
                      _buildInfoRow('Description', data['description']),
                      _buildInfoRow('Location', data['location']),
                      _buildInfoRow(
                        'Start Date',
                        data['start_date'] != null
                            ? _formatDateTime(data['start_date'])
                            : 'Not set',
                      ),
                      _buildInfoRow(
                        'End Date',
                        data['end_date'] != null
                            ? _formatDateTime(data['end_date'])
                            : 'Not set',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Additional Details
                  _buildSection(
                    'Additional Details',
                    [
                      _buildInfoRow(
                        'Max Participants',
                        data['max_participants']?.toString() ?? 'Unlimited',
                      ),
                      _buildInfoRow('Requirements', data['requirements']),
                      _buildInfoRow('Prizes', data['prizes']),
                      _buildInfoRow('Rules', data['rules']),
                      _buildTagsRow('Tags', List<String>.from(data['tags'] ?? [])),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Landing Page Configuration
                  _buildSection(
                    'Landing Page Configuration',
                    [
                      _buildInfoRow(
                        'Template',
                        (data['landing_page_config']?['template_type'] ?? 'default')
                            .toString()
                            .toUpperCase(),
                      ),
                      _buildColorRow(
                        'Primary Color',
                        data['landing_page_config']?['primary_color'] ?? '#2196F3',
                      ),
                      _buildInfoRow(
                        'Logo URL',
                        data['landing_page_config']?['logo_url']?.isEmpty ?? true
                            ? 'Not set'
                            : data['landing_page_config']['logo_url'],
                      ),
                      _buildSponsorsRow(
                        'Sponsors',
                        List<Map<String, String>>.from(
                          data['landing_page_config']?['sponsors'] ?? [],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Once created, you can edit most details later. The landing page will be immediately available for participants.',
                            style: ThemeConfig.bodyMedium.copyWith(
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              CustomButton(
                text: 'Previous',
                onPressed: onPrevious,
                outlined: true,
                icon: Icons.arrow_back,
              ),
              const Spacer(),
              Consumer<HackathonProvider>(
                builder: (context, provider, child) {
                  return CustomButton(
                    text: 'Create Hackathon',
                    onPressed: onSubmit,
                    isLoading: provider.isLoading,
                    icon: Icons.rocket_launch,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeConfig.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: ThemeConfig.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsRow(String label, List<String> tags) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: tags.isEmpty
                ? Text(
                    'No tags added',
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: Colors.grey[500],
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: ThemeConfig.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tag,
                          style: ThemeConfig.bodySmall.copyWith(
                            color: ThemeConfig.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, String colorHex) {
    Color color;
    try {
      final colorValue = int.parse(colorHex.replaceFirst('#', ''), radix: 16);
      color = Color(0xFF000000 | colorValue);
    } catch (e) {
      color = ThemeConfig.primaryColor;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            colorHex.toUpperCase(),
            style: ThemeConfig.bodyMedium.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsRow(String label, List<Map<String, String>> sponsors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: ThemeConfig.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: sponsors.isEmpty
                ? Text(
                    'No sponsors added',
                    style: ThemeConfig.bodyMedium.copyWith(
                      color: Colors.grey[500],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sponsors.map((sponsor) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          sponsor['name']!,
                          style: ThemeConfig.bodyMedium,
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
