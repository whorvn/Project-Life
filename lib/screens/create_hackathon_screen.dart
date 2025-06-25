import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/hackathon_provider.dart';
import '../config/theme_config.dart';
import '../widgets/step_indicator.dart';
import 'hackathon_create_steps/basic_info_step.dart';
import 'hackathon_create_steps/details_step.dart';
import 'hackathon_create_steps/landing_page_step.dart';
import 'hackathon_create_steps/review_step.dart';

class CreateHackathonScreen extends StatefulWidget {
  const CreateHackathonScreen({Key? key}) : super(key: key);

  @override
  State<CreateHackathonScreen> createState() => _CreateHackathonScreenState();
}

class _CreateHackathonScreenState extends State<CreateHackathonScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form data
  final Map<String, dynamic> _hackathonData = {
    'title': '',
    'description': '',
    'start_date': null,
    'end_date': null,
    'location': '',
    'max_participants': null,
    'tags': <String>[],
    'requirements': '',
    'prizes': '',
    'rules': '',
    'landing_page_config': {
      'template_type': 'default',
      'primary_color': '#2196F3',
      'logo_url': '',
      'sponsors': <Map<String, String>>[],
    },
  };

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitHackathon() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create a hackathon'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Convert dates to ISO format
    final data = Map<String, dynamic>.from(_hackathonData);
    if (data['start_date'] != null) {
      data['start_date'] = (data['start_date'] as DateTime).toIso8601String();
    }
    if (data['end_date'] != null) {
      data['end_date'] = (data['end_date'] as DateTime).toIso8601String();
    }

    final hackathon = await hackathonProvider.createHackathon(
      data,
      authProvider.token!,
    );

    if (hackathon != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hackathon created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          '/hackathon/detail',
          arguments: hackathon.id,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(hackathonProvider.error ?? 'Failed to create hackathon'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Hackathon'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Step indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: StepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepTitles: const [
                'Basic Info',
                'Details',
                'Landing Page',
                'Review',
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                BasicInfoStep(
                  data: _hackathonData,
                  onNext: _nextStep,
                ),
                DetailsStep(
                  data: _hackathonData,
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                ),
                LandingPageStep(
                  data: _hackathonData,
                  onNext: _nextStep,
                  onPrevious: _previousStep,
                ),
                ReviewStep(
                  data: _hackathonData,
                  onSubmit: _submitHackathon,
                  onPrevious: _previousStep,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
