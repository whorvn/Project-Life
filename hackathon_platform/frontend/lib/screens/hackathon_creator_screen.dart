import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../models/hackathon.dart';
import '../widgets/hackathon_wizard/basic_info_step.dart';
import '../widgets/hackathon_wizard/timeline_step.dart';
import '../widgets/hackathon_wizard/landing_page_step.dart';
import '../widgets/loading_overlay.dart';

class HackathonCreatorScreen extends StatefulWidget {
  final Hackathon? hackathon;

  const HackathonCreatorScreen({
    super.key,
    this.hackathon,
  });

  @override
  State<HackathonCreatorScreen> createState() => _HackathonCreatorScreenState();
}

class _HackathonCreatorScreenState extends State<HackathonCreatorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Form data
  final Map<String, dynamic> _formData = {};

  bool get isEditing => widget.hackathon != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _populateFormData();
    }
  }

  void _populateFormData() {
    final hackathon = widget.hackathon!;
    _formData.addAll({
      'title': hackathon.title,
      'description': hackathon.description,
      'start_date': hackathon.startDate.toIso8601String(),
      'end_date': hackathon.endDate.toIso8601String(),
      'max_participants': hackathon.maxParticipants,
      'max_team_size': hackathon.maxTeamSize,
      'status': hackathon.status,
      'prizes': hackathon.prizes,
      'rules': hackathon.rules,
      'requirements': hackathon.requirements,
      'judging_criteria': hackathon.judgingCriteria,
      'landing_page_config': hackathon.landingPageConfig,
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
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

  Future<void> _saveHackathon() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
      
      Hackathon? result;
      if (isEditing) {
        result = await hackathonProvider.updateHackathon(
          widget.hackathon!.id,
          _formData,
        );
      } else {
        result = await hackathonProvider.createHackathon(_formData);
      }

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing 
                  ? 'Hackathon updated successfully!'
                  : 'Hackathon created successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateFormData(Map<String, dynamic> stepData) {
    _formData.addAll(stepData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Hackathon' : 'Create Hackathon',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: Column(
          children: [
            // Progress indicator
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < 3; i++) ...[
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: i <= _currentStep
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        if (i < 2)
                          Container(
                            width: 8,
                            height: 4,
                            color: Colors.transparent,
                          ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Basic Info',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _currentStep >= 0
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: _currentStep == 0 ? FontWeight.bold : null,
                        ),
                      ),
                      Text(
                        'Timeline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _currentStep >= 1
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: _currentStep == 1 ? FontWeight.bold : null,
                        ),
                      ),
                      Text(
                        'Landing Page',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _currentStep >= 2
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight: _currentStep == 2 ? FontWeight.bold : null,
                        ),
                      ),
                    ],
                  ),
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
                    initialData: _formData,
                    onDataChanged: _updateFormData,
                  ),
                  TimelineStep(
                    initialData: _formData,
                    onDataChanged: _updateFormData,
                  ),
                  LandingPageStep(
                    initialData: _formData,
                    onDataChanged: _updateFormData,
                  ),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _currentStep < 2 ? _nextStep : _saveHackathon,
                      child: Text(
                        _currentStep < 2 
                            ? 'Next' 
                            : (isEditing ? 'Update' : 'Create'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
