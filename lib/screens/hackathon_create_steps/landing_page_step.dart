import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/color_picker_widget.dart';

class LandingPageStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const LandingPageStep({
    Key? key,
    required this.data,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<LandingPageStep> createState() => _LandingPageStepState();
}

class _LandingPageStepState extends State<LandingPageStep> {
  late Map<String, dynamic> _landingPageConfig;
  late TextEditingController _logoUrlController;
  late TextEditingController _sponsorNameController;
  late TextEditingController _sponsorUrlController;
  List<Map<String, String>> _sponsors = [];

  final List<String> _templateTypes = ['default', 'modern', 'minimal'];
  final Map<String, String> _templateDescriptions = {
    'default': 'Classic design with hero section and feature highlights',
    'modern': 'Contemporary layout with animations and gradients',
    'minimal': 'Clean and simple design focused on content',
  };

  @override
  void initState() {
    super.initState();
    _landingPageConfig = Map<String, dynamic>.from(
      widget.data['landing_page_config'] ?? {
        'template_type': 'default',
        'primary_color': '#2196F3',
        'logo_url': '',
        'sponsors': <Map<String, String>>[],
      },
    );
    _logoUrlController = TextEditingController(text: _landingPageConfig['logo_url']);
    _sponsorNameController = TextEditingController();
    _sponsorUrlController = TextEditingController();
    _sponsors = List<Map<String, String>>.from(_landingPageConfig['sponsors'] ?? []);
  }

  @override
  void dispose() {
    _logoUrlController.dispose();
    _sponsorNameController.dispose();
    _sponsorUrlController.dispose();
    super.dispose();
  }

  void _addSponsor() {
    final name = _sponsorNameController.text.trim();
    final url = _sponsorUrlController.text.trim();
    
    if (name.isNotEmpty && url.isNotEmpty) {
      setState(() {
        _sponsors.add({'name': name, 'logo_url': url});
        _sponsorNameController.clear();
        _sponsorUrlController.clear();
      });
    }
  }

  void _removeSponsor(int index) {
    setState(() {
      _sponsors.removeAt(index);
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _landingPageConfig['primary_color'] = '#${color.value.toRadixString(16).substring(2)}';
    });
  }

  void _previewLandingPage() {
    // Update the config with current data
    _landingPageConfig['logo_url'] = _logoUrlController.text.trim();
    _landingPageConfig['sponsors'] = _sponsors;
    widget.data['landing_page_config'] = _landingPageConfig;

    // Navigate to preview
    Navigator.pushNamed(
      context,
      '/hackathon/landing-page-preview',
      arguments: {
        'hackathonData': widget.data,
        'isPreview': true,
      },
    );
  }

  void _next() {
    _landingPageConfig['logo_url'] = _logoUrlController.text.trim();
    _landingPageConfig['sponsors'] = _sponsors;
    widget.data['landing_page_config'] = _landingPageConfig;
    widget.onNext();
  }

  Color _getColorFromHex(String hex) {
    try {
      final colorValue = int.parse(hex.replaceFirst('#', ''), radix: 16);
      return Color(0xFF000000 | colorValue);
    } catch (e) {
      return ThemeConfig.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Landing Page Design',
            style: ThemeConfig.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize how your hackathon landing page will look.',
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
                  // Template Selection
                  Text(
                    'Choose Template',
                    style: ThemeConfig.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  ..._templateTypes.map((template) {
                    final isSelected = _landingPageConfig['template_type'] == template;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _landingPageConfig['template_type'] = template;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected ? ThemeConfig.primaryColor : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: isSelected ? ThemeConfig.primaryColor.withOpacity(0.05) : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? ThemeConfig.primaryColor : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: ThemeConfig.primaryColor,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      template.toUpperCase(),
                                      style: ThemeConfig.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? ThemeConfig.primaryColor : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _templateDescriptions[template]!,
                                      style: ThemeConfig.bodySmall.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Color Picker
                  Text(
                    'Primary Color',
                    style: ThemeConfig.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ColorPickerWidget(
                    initialColor: _getColorFromHex(_landingPageConfig['primary_color']),
                    onColorChanged: _onColorChanged,
                  ),
                  const SizedBox(height: 24),

                  // Logo URL
                  CustomTextField(
                    controller: _logoUrlController,
                    label: 'Logo URL (Optional)',
                    hintText: 'https://example.com/logo.png',
                  ),
                  const SizedBox(height: 24),

                  // Sponsors Section
                  Text(
                    'Sponsors',
                    style: ThemeConfig.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _sponsorNameController,
                          label: 'Sponsor Name',
                          hintText: 'e.g., TechCorp',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          controller: _sponsorUrlController,
                          label: 'Logo URL',
                          hintText: 'https://example.com/logo.png',
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: 'Add',
                        onPressed: _addSponsor,
                        width: 80,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sponsors List
                  if (_sponsors.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Added Sponsors',
                            style: ThemeConfig.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._sponsors.asMap().entries.map((entry) {
                            final index = entry.key;
                            final sponsor = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sponsor['name']!,
                                          style: ThemeConfig.bodyMedium.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          sponsor['logo_url']!,
                                          style: ThemeConfig.bodySmall.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _removeSponsor(index),
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Preview Button
                  Center(
                    child: CustomButton(
                      text: 'Preview Landing Page',
                      onPressed: _previewLandingPage,
                      icon: Icons.preview,
                      outlined: true,
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
                onPressed: widget.onPrevious,
                outlined: true,
                icon: Icons.arrow_back,
              ),
              const Spacer(),
              CustomButton(
                text: 'Next',
                onPressed: _next,
                icon: Icons.arrow_forward,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
