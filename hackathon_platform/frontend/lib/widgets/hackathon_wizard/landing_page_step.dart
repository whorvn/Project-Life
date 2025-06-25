import 'package:flutter/material.dart';

class LandingPageStep extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const LandingPageStep({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<LandingPageStep> createState() => _LandingPageStepState();
}

class _LandingPageStepState extends State<LandingPageStep> {
  final _formKey = GlobalKey<FormState>();
  
  // Landing page configuration
  late TextEditingController _heroTitleController;
  late TextEditingController _heroSubtitleController;
  late TextEditingController _aboutSectionController;
  late TextEditingController _sponsorsController;
  late TextEditingController _contactEmailController;
  late TextEditingController _contactPhoneController;
  late TextEditingController _locationController;
  late TextEditingController _socialLinksController;
  
  String _selectedTheme = 'modern';
  String _selectedColorScheme = 'blue';
  bool _showCountdown = true;
  bool _showPrizes = true;
  bool _showSponsors = true;
  bool _showFAQ = true;

  @override
  void initState() {
    super.initState();
    
    final config = widget.initialData['landing_page_config'] as Map<String, dynamic>? ?? {};
    
    _heroTitleController = TextEditingController(
      text: config['hero_title'] ?? widget.initialData['title'] ?? '',
    );
    _heroSubtitleController = TextEditingController(
      text: config['hero_subtitle'] ?? widget.initialData['description'] ?? '',
    );
    _aboutSectionController = TextEditingController(
      text: config['about_section'] ?? '',
    );
    _sponsorsController = TextEditingController(
      text: config['sponsors'] ?? '',
    );
    _contactEmailController = TextEditingController(
      text: config['contact_email'] ?? '',
    );
    _contactPhoneController = TextEditingController(
      text: config['contact_phone'] ?? '',
    );
    _locationController = TextEditingController(
      text: config['location'] ?? '',
    );
    _socialLinksController = TextEditingController(
      text: config['social_links'] ?? '',
    );
    
    _selectedTheme = config['theme'] ?? 'modern';
    _selectedColorScheme = config['color_scheme'] ?? 'blue';
    _showCountdown = config['show_countdown'] ?? true;
    _showPrizes = config['show_prizes'] ?? true;
    _showSponsors = config['show_sponsors'] ?? true;
    _showFAQ = config['show_faq'] ?? true;

    // Listen to changes
    _heroTitleController.addListener(_updateData);
    _heroSubtitleController.addListener(_updateData);
    _aboutSectionController.addListener(_updateData);
    _sponsorsController.addListener(_updateData);
    _contactEmailController.addListener(_updateData);
    _contactPhoneController.addListener(_updateData);
    _locationController.addListener(_updateData);
    _socialLinksController.addListener(_updateData);
  }

  @override
  void dispose() {
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _aboutSectionController.dispose();
    _sponsorsController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _locationController.dispose();
    _socialLinksController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.onDataChanged({
      'landing_page_config': {
        'hero_title': _heroTitleController.text,
        'hero_subtitle': _heroSubtitleController.text,
        'about_section': _aboutSectionController.text,
        'sponsors': _sponsorsController.text,
        'contact_email': _contactEmailController.text,
        'contact_phone': _contactPhoneController.text,
        'location': _locationController.text,
        'social_links': _socialLinksController.text,
        'theme': _selectedTheme,
        'color_scheme': _selectedColorScheme,
        'show_countdown': _showCountdown,
        'show_prizes': _showPrizes,
        'show_sponsors': _showSponsors,
        'show_faq': _showFAQ,
      }
    });
  }

  Color _getSchemeColor(String scheme) {
    switch (scheme) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Landing Page Configuration',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Customize how your hackathon will appear to participants',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              // Theme Selection
              Text(
                'Visual Design',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedTheme,
                      decoration: const InputDecoration(
                        labelText: 'Theme Style',
                        prefixIcon: Icon(Icons.palette),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'modern', child: Text('Modern')),
                        DropdownMenuItem(value: 'classic', child: Text('Classic')),
                        DropdownMenuItem(value: 'tech', child: Text('Tech')),
                        DropdownMenuItem(value: 'creative', child: Text('Creative')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTheme = value;
                          });
                          _updateData();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedColorScheme,
                      decoration: const InputDecoration(
                        labelText: 'Color Scheme',
                        prefixIcon: Icon(Icons.color_lens),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'blue',
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Blue'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'green',
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Green'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'purple',
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Purple'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'orange',
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Orange'),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'red',
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('Red'),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedColorScheme = value;
                          });
                          _updateData();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Hero Section
              Text(
                'Hero Section',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _heroTitleController,
                decoration: const InputDecoration(
                  labelText: 'Hero Title',
                  hintText: 'Main headline for your landing page',
                  prefixIcon: Icon(Icons.title),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _heroSubtitleController,
                decoration: const InputDecoration(
                  labelText: 'Hero Subtitle',
                  hintText: 'Compelling subtitle to attract participants',
                  prefixIcon: Icon(Icons.subtitles),
                  alignLabelWithHint: true,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              
              // About Section
              Text(
                'Content Sections',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _aboutSectionController,
                decoration: const InputDecoration(
                  labelText: 'About Section',
                  hintText: 'Detailed description of your hackathon...',
                  prefixIcon: Icon(Icons.info),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _sponsorsController,
                decoration: const InputDecoration(
                  labelText: 'Sponsors',
                  hintText: 'List your sponsors and partners...',
                  prefixIcon: Icon(Icons.business),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              
              // Contact Information
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _contactEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _contactPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Phone',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Event Location',
                  hintText: 'Venue address or online platform details',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _socialLinksController,
                decoration: const InputDecoration(
                  labelText: 'Social Media Links',
                  hintText: 'Twitter, LinkedIn, Discord, etc. (one per line)',
                  prefixIcon: Icon(Icons.share),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              
              // Section Toggles
              Text(
                'Page Sections',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Show Countdown Timer'),
                        subtitle: const Text('Display countdown to event start'),
                        value: _showCountdown,
                        onChanged: (value) {
                          setState(() {
                            _showCountdown = value;
                          });
                          _updateData();
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Show Prizes Section'),
                        subtitle: const Text('Display prizes and rewards'),
                        value: _showPrizes,
                        onChanged: (value) {
                          setState(() {
                            _showPrizes = value;
                          });
                          _updateData();
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Show Sponsors Section'),
                        subtitle: const Text('Display sponsors and partners'),
                        value: _showSponsors,
                        onChanged: (value) {
                          setState(() {
                            _showSponsors = value;
                          });
                          _updateData();
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Show FAQ Section'),
                        subtitle: const Text('Include frequently asked questions'),
                        value: _showFAQ,
                        onChanged: (value) {
                          setState(() {
                            _showFAQ = value;
                          });
                          _updateData();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Preview Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _getSchemeColor(_selectedColorScheme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getSchemeColor(_selectedColorScheme).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.preview,
                          color: _getSchemeColor(_selectedColorScheme),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Landing Page Preview',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getSchemeColor(_selectedColorScheme),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Mini preview
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _heroTitleController.text.isNotEmpty 
                                ? _heroTitleController.text 
                                : 'Your Hackathon Title',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getSchemeColor(_selectedColorScheme),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _heroSubtitleController.text.isNotEmpty 
                                ? _heroSubtitleController.text 
                                : 'Your hackathon subtitle will appear here',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_showCountdown)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getSchemeColor(_selectedColorScheme).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Countdown Timer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _getSchemeColor(_selectedColorScheme),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This is a simplified preview. Your actual landing page will include all configured sections and styling.',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getSchemeColor(_selectedColorScheme),
                        fontStyle: FontStyle.italic,
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
  }
}
