import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class LandingPagePreviewScreen extends StatelessWidget {
  const LandingPagePreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final hackathonData = args?['hackathonData'] as Map<String, dynamic>? ?? {};
    final isPreview = args?['isPreview'] as bool? ?? false;

    final landingPageConfig = hackathonData['landing_page_config'] as Map<String, dynamic>? ?? {};
    final primaryColorHex = landingPageConfig['primary_color'] as String? ?? '#2196F3';
    final templateType = landingPageConfig['template_type'] as String? ?? 'default';
    final logoUrl = landingPageConfig['logo_url'] as String? ?? '';
    final sponsors = List<Map<String, String>>.from(landingPageConfig['sponsors'] ?? []);

    Color primaryColor;
    try {
      final colorValue = int.parse(primaryColorHex.replaceFirst('#', ''), radix: 16);
      primaryColor = Color(0xFF000000 | colorValue);
    } catch (e) {
      primaryColor = ThemeConfig.primaryColor;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPreview ? 'Landing Page Preview' : 'Hackathon Landing Page'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          if (isPreview)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close Preview'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: _buildLandingPage(
          hackathonData,
          primaryColor,
          templateType,
          logoUrl,
          sponsors,
        ),
      ),
    );
  }

  Widget _buildLandingPage(
    Map<String, dynamic> hackathonData,
    Color primaryColor,
    String templateType,
    String logoUrl,
    List<Map<String, String>> sponsors,
  ) {
    switch (templateType) {
      case 'modern':
        return _buildModernTemplate(hackathonData, primaryColor, logoUrl, sponsors);
      case 'minimal':
        return _buildMinimalTemplate(hackathonData, primaryColor, logoUrl, sponsors);
      default:
        return _buildDefaultTemplate(hackathonData, primaryColor, logoUrl, sponsors);
    }
  }

  Widget _buildDefaultTemplate(
    Map<String, dynamic> hackathonData,
    Color primaryColor,
    String logoUrl,
    List<Map<String, String>> sponsors,
  ) {
    return Column(
      children: [
        // Hero Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              if (logoUrl.isNotEmpty) ...[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 24),
              ],
              Text(
                hackathonData['title'] ?? 'Hackathon Title',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                hackathonData['description'] ?? 'Hackathon Description',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Register Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // Details Section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
          child: Column(
            children: [
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailCard(
                      Icons.calendar_today,
                      'Date',
                      _formatDateRange(hackathonData['start_date'], hackathonData['end_date']),
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDetailCard(
                      Icons.location_on,
                      'Location',
                      hackathonData['location'] ?? 'TBA',
                      primaryColor,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDetailCard(
                      Icons.people,
                      'Participants',
                      hackathonData['max_participants']?.toString() ?? 'Unlimited',
                      primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Prizes Section
        if (hackathonData['prizes']?.isNotEmpty ?? false) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            color: Colors.grey[50],
            child: Column(
              children: [
                const Text(
                  'Prizes',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  hackathonData['prizes'],
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],

        // Sponsors Section
        if (sponsors.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Column(
              children: [
                const Text(
                  'Sponsors',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  spacing: 32,
                  runSpacing: 32,
                  alignment: WrapAlignment.center,
                  children: sponsors.map((sponsor) {
                    return Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.business, size: 50, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(sponsor['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],

        // Footer
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          color: Colors.grey[900],
          child: Text(
            '© 2024 ${hackathonData['title'] ?? 'Hackathon'}. All rights reserved.',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTemplate(
    Map<String, dynamic> hackathonData,
    Color primaryColor,
    String logoUrl,
    List<Map<String, String>> sponsors,
  ) {
    // Similar structure but with modern styling
    return _buildDefaultTemplate(hackathonData, primaryColor, logoUrl, sponsors);
  }

  Widget _buildMinimalTemplate(
    Map<String, dynamic> hackathonData,
    Color primaryColor,
    String logoUrl,
    List<Map<String, String>> sponsors,
  ) {
    // Similar structure but with minimal styling
    return _buildDefaultTemplate(hackathonData, primaryColor, logoUrl, sponsors);
  }

  Widget _buildDetailCard(IconData icon, String title, String content, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: primaryColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateRange(dynamic startDate, dynamic endDate) {
    if (startDate == null || endDate == null) return 'TBA';
    
    try {
      DateTime start = startDate is DateTime ? startDate : DateTime.parse(startDate);
      DateTime end = endDate is DateTime ? endDate : DateTime.parse(endDate);
      
      return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
    } catch (e) {
      return 'TBA';
    }
  }
}
