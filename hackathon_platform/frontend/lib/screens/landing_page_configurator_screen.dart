import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../providers/auth_provider.dart';
import '../models/landing_page.dart';
import '../widgets/loading_overlay.dart';

class LandingPageConfiguratorScreen extends StatefulWidget {
  final String? hackathonId; // null for new hackathon
  
  const LandingPageConfiguratorScreen({
    Key? key,
    this.hackathonId,
  }) : super(key: key);

  @override
  State<LandingPageConfiguratorScreen> createState() =>
      _LandingPageConfiguratorScreenState();
}

class _LandingPageConfiguratorScreenState
    extends State<LandingPageConfiguratorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  // Landing page data
  LandingPageData _landingPageData = LandingPageData();
  
  // Form controllers
  final _primaryColorController = TextEditingController(text: '#1976d2');
  final _secondaryColorController = TextEditingController(text: '#424242');
  final _accentColorController = TextEditingController(text: '#ff4081');
  final _logoUrlController = TextEditingController();
  final _heroBannerUrlController = TextEditingController();
  final _heroOverlayTextController = TextEditingController();
  final _seoTitleController = TextEditingController();
  final _seoDescriptionController = TextEditingController();
  final _seoKeywordsController = TextEditingController();

  // Sponsors list
  List<SponsorData> _sponsors = [];
  
  // Key features list
  List<String> _keyFeatures = [];
  
  // FAQ list
  List<FAQItem> _faqItems = [];
  
  // Venue photos list
  List<String> _venuePhotos = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadExistingData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _accentColorController.dispose();
    _logoUrlController.dispose();
    _heroBannerUrlController.dispose();
    _heroOverlayTextController.dispose();
    _seoTitleController.dispose();
    _seoDescriptionController.dispose();
    _seoKeywordsController.dispose();
    super.dispose();
  }

  void _loadExistingData() async {
    if (widget.hackathonId != null) {
      setState(() => _isLoading = true);
      try {
        final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
        final hackathon = await hackathonProvider.getHackathon(widget.hackathonId!);
        if (hackathon != null) {
          _loadDataFromHackathon(hackathon);
        }
      } catch (e) {
        _showError('Failed to load hackathon data: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _loadDataFromHackathon(dynamic hackathon) {
    // Load existing landing page data
    _primaryColorController.text = hackathon.landingPrimaryColor ?? '#1976d2';
    _secondaryColorController.text = hackathon.landingSecondaryColor ?? '#424242';
    _accentColorController.text = hackathon.landingAccentColor ?? '#ff4081';
    _logoUrlController.text = hackathon.landingLogoUrl ?? '';
    _heroBannerUrlController.text = hackathon.landingHeroBannerUrl ?? '';
    _heroOverlayTextController.text = hackathon.landingHeroOverlayText ?? '';
    _seoTitleController.text = hackathon.landingSeoTitle ?? '';
    _seoDescriptionController.text = hackathon.landingSeoDescription ?? '';
    _seoKeywordsController.text = hackathon.landingSeoKeywords ?? '';
    
    // Load complex data structures
    if (hackathon.sponsorsData != null) {
      _sponsors = hackathon.sponsorsData!.map<SponsorData>((data) => 
          SponsorData.fromJson(Map<String, dynamic>.from(data))).toList();
    }
    
    if (hackathon.landingKeyFeatures != null) {
      _keyFeatures = List<String>.from(hackathon.landingKeyFeatures!);
    }
    
    if (hackathon.landingFaqData != null) {
      _faqItems = hackathon.landingFaqData!.map<FAQItem>((data) => 
          FAQItem.fromJson(Map<String, dynamic>.from(data))).toList();
    }
    
    if (hackathon.landingVenuePhotos != null) {
      _venuePhotos = List<String>.from(hackathon.landingVenuePhotos!);
    }
    
    setState(() {});
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _saveAndContinue() async {
    setState(() => _isLoading = true);
    
    try {
      // Collect all data
      _landingPageData = LandingPageData(
        landingPrimaryColor: _primaryColorController.text,
        landingSecondaryColor: _secondaryColorController.text,
        landingAccentColor: _accentColorController.text,
        landingLogoUrl: _logoUrlController.text.isNotEmpty ? _logoUrlController.text : null,
        landingHeroBannerUrl: _heroBannerUrlController.text.isNotEmpty ? _heroBannerUrlController.text : null,
        landingHeroOverlayText: _heroOverlayTextController.text.isNotEmpty ? _heroOverlayTextController.text : null,
        sponsorsData: _sponsors.isNotEmpty ? _sponsors : null,
        landingKeyFeatures: _keyFeatures.isNotEmpty ? _keyFeatures : null,
        landingFaqData: _faqItems.isNotEmpty ? _faqItems : null,
        landingVenuePhotos: _venuePhotos.isNotEmpty ? _venuePhotos : null,
        landingSeoTitle: _seoTitleController.text.isNotEmpty ? _seoTitleController.text : null,
        landingSeoDescription: _seoDescriptionController.text.isNotEmpty ? _seoDescriptionController.text : null,
        landingSeoKeywords: _seoKeywordsController.text.isNotEmpty ? _seoKeywordsController.text : null,
        hasSponsors: _sponsors.isNotEmpty,
      );
      
      _showSuccess('Landing page configuration saved!');
      
      // Navigate to hackathon wizard with landing page data
      Navigator.of(context).pushReplacementNamed(
        '/hackathon-creator',
        arguments: {'landingPageData': _landingPageData},
      );
      
    } catch (e) {
      _showError('Failed to save configuration: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page Configurator'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Visual Branding'),
            Tab(text: 'Sponsors'),
            Tab(text: 'Event Highlights'),
            Tab(text: 'Interactive Elements'),
            Tab(text: 'SEO & Analytics'),
            Tab(text: 'Preview'),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildVisualBrandingTab(),
            _buildSponsorsTab(),
            _buildEventHighlightsTab(),
            _buildInteractiveElementsTab(),
            _buildSEOAnalyticsTab(),
            _buildPreviewTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndContinue,
        label: const Text('Continue to Wizard'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _buildVisualBrandingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Color Scheme'),
          _buildColorInput('Primary Color', _primaryColorController),
          _buildColorInput('Secondary Color', _secondaryColorController),
          _buildColorInput('Accent Color', _accentColorController),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Logo & Branding'),
          _buildTextInput('Logo URL', _logoUrlController),
          _buildDropdown('Logo Position', _landingPageData.landingLogoPosition, 
              ['left', 'center', 'right'], (value) {
            setState(() => _landingPageData.landingLogoPosition = value!);
          }),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Hero Section'),
          _buildTextInput('Hero Banner URL', _heroBannerUrlController),
          _buildTextInput('Hero Overlay Text', _heroOverlayTextController, maxLines: 3),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Typography'),
          _buildDropdown('Heading Font', _landingPageData.landingTypographyHeading,
              ['Roboto', 'Open Sans', 'Lato', 'Montserrat', 'Poppins'], (value) {
            setState(() => _landingPageData.landingTypographyHeading = value!);
          }),
          _buildDropdown('Body Font', _landingPageData.landingTypographyBody,
              ['Open Sans', 'Roboto', 'Lato', 'Source Sans Pro'], (value) {
            setState(() => _landingPageData.landingTypographyBody = value!);
          }),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Background & Buttons'),
          _buildDropdown('Background Type', _landingPageData.landingBackgroundType,
              ['solid', 'gradient', 'pattern', 'image'], (value) {
            setState(() => _landingPageData.landingBackgroundType = value!);
          }),
          _buildDropdown('Button Style', _landingPageData.landingButtonStyle,
              ['rounded', 'square', 'gradient'], (value) {
            setState(() => _landingPageData.landingButtonStyle = value!);
          }),
        ],
      ),
    );
  }

  Widget _buildSponsorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Sponsors'),
              ElevatedButton.icon(
                onPressed: _addSponsor,
                icon: const Icon(Icons.add),
                label: const Text('Add Sponsor'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._sponsors.asMap().entries.map((entry) => 
              _buildSponsorCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildEventHighlightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Key Features'),
              ElevatedButton.icon(
                onPressed: _addKeyFeature,
                icon: const Icon(Icons.add),
                label: const Text('Add Feature'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._keyFeatures.asMap().entries.map((entry) => 
              _buildKeyFeatureCard(entry.key, entry.value)),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('Venue Photos'),
              ElevatedButton.icon(
                onPressed: _addVenuePhoto,
                icon: const Icon(Icons.add),
                label: const Text('Add Photo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._venuePhotos.asMap().entries.map((entry) => 
              _buildVenuePhotoCard(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildInteractiveElementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('FAQ Section'),
              ElevatedButton.icon(
                onPressed: _addFAQ,
                icon: const Icon(Icons.add),
                label: const Text('Add FAQ'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._faqItems.asMap().entries.map((entry) => 
              _buildFAQCard(entry.key, entry.value)),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Contact Information'),
          // TODO: Add contact info fields
          
          const SizedBox(height: 24),
          _buildSectionTitle('Social Media'),
          // TODO: Add social media fields
        ],
      ),
    );
  }

  Widget _buildSEOAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('SEO Settings'),
          _buildTextInput('SEO Title', _seoTitleController),
          _buildTextInput('SEO Description', _seoDescriptionController, maxLines: 3),
          _buildTextInput('SEO Keywords', _seoKeywordsController),
          
          const SizedBox(height: 24),
          _buildSectionTitle('Analytics'),
          SwitchListTile(
            title: const Text('Enable Analytics'),
            subtitle: const Text('Track page views and registration clicks'),
            value: _landingPageData.landingAnalyticsEnabled,
            onChanged: (value) {
              setState(() => _landingPageData.landingAnalyticsEnabled = value);
            },
          ),
          SwitchListTile(
            title: const Text('Mobile Optimization'),
            subtitle: const Text('Ensure mobile-friendly design'),
            value: _landingPageData.landingMobileOptimized,
            onChanged: (value) {
              setState(() => _landingPageData.landingMobileOptimized = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Landing Page Preview'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Colors: Primary ${_primaryColorController.text}, '
                       'Secondary ${_secondaryColorController.text}'),
                  if (_logoUrlController.text.isNotEmpty)
                    Text('Logo: ${_logoUrlController.text}'),
                  if (_heroBannerUrlController.text.isNotEmpty)
                    Text('Hero Banner: ${_heroBannerUrlController.text}'),
                  if (_sponsors.isNotEmpty)
                    Text('Sponsors: ${_sponsors.length} configured'),
                  if (_keyFeatures.isNotEmpty)
                    Text('Key Features: ${_keyFeatures.length} items'),
                  if (_faqItems.isNotEmpty)
                    Text('FAQ Items: ${_faqItems.length} questions'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildColorInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _parseColor(controller.text),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(String label, T value, List<T> items, ValueChanged<T?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item.toString()),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSponsorCard(int index, SponsorData sponsor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('${sponsor.name} (${sponsor.tier})',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  onPressed: () => _removeSponsor(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            // TODO: Add sponsor editing fields
          ],
        ),
      ),
    );
  }

  Widget _buildKeyFeatureCard(int index, String feature) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(feature),
        trailing: IconButton(
          onPressed: () => _removeKeyFeature(index),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildVenuePhotoCard(int index, String photoUrl) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(photoUrl),
        trailing: IconButton(
          onPressed: () => _removeVenuePhoto(index),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildFAQCard(int index, FAQItem faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Q: ${faq.question}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  onPressed: () => _removeFAQ(index),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            Text('A: ${faq.answer}'),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  void _addSponsor() {
    setState(() {
      _sponsors.add(SponsorData(name: 'New Sponsor', tier: 'bronze'));
    });
  }

  void _removeSponsor(int index) {
    setState(() => _sponsors.removeAt(index));
  }

  void _addKeyFeature() {
    // TODO: Show dialog to add key feature
    setState(() {
      _keyFeatures.add('New Feature');
    });
  }

  void _removeKeyFeature(int index) {
    setState(() => _keyFeatures.removeAt(index));
  }

  void _addVenuePhoto() {
    // TODO: Show dialog to add venue photo URL
    setState(() {
      _venuePhotos.add('https://example.com/photo.jpg');
    });
  }

  void _removeVenuePhoto(int index) {
    setState(() => _venuePhotos.removeAt(index));
  }

  void _addFAQ() {
    // TODO: Show dialog to add FAQ
    setState(() {
      _faqItems.add(FAQItem(question: 'New Question', answer: 'New Answer'));
    });
  }

  void _removeFAQ(int index) {
    setState(() => _faqItems.removeAt(index));
  }
}
