import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../widgets/loading_overlay.dart';

class HackathonCreatorScreen extends StatefulWidget {
  const HackathonCreatorScreen({super.key});

  @override
  State<HackathonCreatorScreen> createState() => _HackathonCreatorScreenState();
}

class _HackathonCreatorScreenState extends State<HackathonCreatorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Pre-filled demo data
  final TextEditingController _nameController = TextEditingController(text: "CodeFest 2025");
  final TextEditingController _descriptionController = TextEditingController(
    text: "Join us for an exciting 48-hour hackathon focused on innovative solutions for sustainable technology. Participants will work in teams to create cutting-edge applications that address environmental challenges and promote sustainability."
  );
  String _selectedType = "Hybrid";
  final TextEditingController _themeController = TextEditingController(text: "Sustainable Tech Solutions");
  
  // Event Details
  DateTime _applicationStartDate = DateTime.now().add(const Duration(days: 7));
  DateTime _applicationEndDate = DateTime.now().add(const Duration(days: 21));
  DateTime _eventStartDate = DateTime.now().add(const Duration(days: 30));
  DateTime _eventEndDate = DateTime.now().add(const Duration(days: 32));
  final TextEditingController _prizePoolController = TextEditingController(
    text: "\$15,000 Total Prize Pool:\n1st Place: \$7,000 + MacBook Pro\n2nd Place: \$4,000 + iPad Pro\n3rd Place: \$2,000 + AirPods Pro\n4th-10th Place: Premium Headphones + Tech Swag"
  );
  
  // Participant Settings
  final TextEditingController _rulesController = TextEditingController(
    text: "1. All code must be original and developed during the hackathon\n2. Teams must submit their projects by the deadline\n3. Projects must align with the sustainability theme\n4. Use of AI tools is allowed but must be disclosed\n5. Respect all participants and maintain a positive environment"
  );
  int _minTeamSize = 2;
  int _maxTeamSize = 6;
  int _maxParticipants = 200;

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

  Future<void> _createHackathon() async {
    try {
      final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
      
      final hackathonData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'type': _selectedType,
        'theme_focus_area': _themeController.text,
        'location': _selectedType == 'Online' ? 'Virtual' : 'TBD',
        'start_date': _eventStartDate.toIso8601String(),
        'end_date': _eventEndDate.toIso8601String(),
        'application_start_date': _applicationStartDate.toIso8601String(),
        'application_end_date': _applicationEndDate.toIso8601String(),
        'application_open': _applicationStartDate.toIso8601String(),
        'application_close': _applicationEndDate.toIso8601String(),
        'prize_pool_details': _prizePoolController.text,
        'rules': _rulesController.text,
        'min_team_size': _minTeamSize,
        'max_team_size': _maxTeamSize,
        'landing_page_type': 'template',
        'landing_color_scheme': '#1976d2',
        'has_sponsors': false,
        'sponsors_data': null,
        'custom_landing_url': null,
        'landing_logo_url': null,
      };

      await hackathonProvider.createHackathon(hackathonData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hackathon created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating hackathon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _themeController.dispose();
    _prizePoolController.dispose();
    _rulesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonProvider>(
      builder: (context, hackathonProvider, child) {
        return LoadingOverlay(
          isLoading: hackathonProvider.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create New Hackathon'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: Column(
              children: [
                // Progress Indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: List.generate(_totalSteps, (index) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                
                // Step Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${_currentStep + 1} of $_totalSteps',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        _getStepTitle(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Page View
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGeneralInformationStep(),
                      _buildEventDetailsStep(),
                      _buildParticipantSettingsStep(),
                    ],
                  ),
                ),
                
                // Navigation Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0)
                        ElevatedButton(
                          onPressed: _previousStep,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Previous'),
                        )
                      else
                        const SizedBox.shrink(),
                      
                      ElevatedButton(
                        onPressed: _currentStep == _totalSteps - 1
                            ? _createHackathon
                            : _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_currentStep == _totalSteps - 1 ? 'Create Hackathon' : 'Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'General Information';
      case 1:
        return 'Event Details';
      case 2:
        return 'Participant Settings';
      default:
        return '';
    }
  }

  Widget _buildGeneralInformationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Captures the core identity and basic structure of the hackathon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Hackathon Name
          _buildTextField(
            controller: _nameController,
            label: 'Hackathon Name *',
            hint: 'e.g., CodeFest 2025',
            helperText: 'A unique name to identify your hackathon',
          ),
          const SizedBox(height: 16),
          
          // Description
          _buildTextField(
            controller: _descriptionController,
            label: 'Description *',
            hint: 'Detailed overview of your hackathon...',
            helperText: 'Describe the purpose, themes, and goals of your hackathon',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          
          // Hackathon Type
          _buildDropdownField(
            value: _selectedType,
            label: 'Hackathon Type *',
            items: ['Online', 'Offline', 'Hybrid'],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
            helperText: 'Select the format of your hackathon',
          ),
          const SizedBox(height: 16),
          
          // Theme or Focus Area
          _buildTextField(
            controller: _themeController,
            label: 'Theme or Focus Area',
            hint: 'e.g., AI for Healthcare, Sustainable Tech',
            helperText: 'Define the main topic or theme for participant projects',
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Event Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Define scheduling and prize-related details for your hackathon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Application Period
          Text(
            'Application Period',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeField(
                  label: 'Application Start *',
                  value: _applicationStartDate,
                  onChanged: (date) {
                    setState(() {
                      _applicationStartDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateTimeField(
                  label: 'Application End *',
                  value: _applicationEndDate,
                  onChanged: (date) {
                    setState(() {
                      _applicationEndDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Event Period
          Text(
            'Event Period',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildDateTimeField(
                  label: 'Event Start *',
                  value: _eventStartDate,
                  onChanged: (date) {
                    setState(() {
                      _eventStartDate = date;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDateTimeField(
                  label: 'Event End *',
                  value: _eventEndDate,
                  onChanged: (date) {
                    setState(() {
                      _eventEndDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Prize Pool Details
          _buildTextField(
            controller: _prizePoolController,
            label: 'Prize Pool Details *',
            hint: 'Describe awards and prize distribution...',
            helperText: 'Detail the prize structure including monetary awards and other prizes',
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantSettingsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participant Settings',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Define rules and requirements for participants',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Hackathon Rules
          _buildTextField(
            controller: _rulesController,
            label: 'Hackathon Rules *',
            hint: 'Outline participation guidelines...',
            helperText: 'Clear rules and guidelines for participants',
            maxLines: 6,
          ),
          const SizedBox(height: 16),
          
          // Team Size Settings
          Text(
            'Team Size Requirements',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: 'Minimum Team Size *',
                  value: _minTeamSize,
                  onChanged: (value) {
                    setState(() {
                      _minTeamSize = value;
                    });
                  },
                  helperText: 'Smallest allowed team size',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildNumberField(
                  label: 'Maximum Team Size *',
                  value: _maxTeamSize,
                  onChanged: (value) {
                    setState(() {
                      _maxTeamSize = value;
                    });
                  },
                  helperText: 'Largest allowed team size',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Maximum Participants
          _buildNumberField(
            label: 'Maximum Participant Cap',
            value: _maxParticipants,
            onChanged: (value) {
              setState(() {
                _maxParticipants = value;
              });
            },
            helperText: 'Total limit of participants for the hackathon',
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? helperText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            helperText: helperText,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            helperText: helperText,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime value,
    required Function(DateTime) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value),
              );
              if (time != null) {
                onChanged(DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                ));
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.shade50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${value.day}/${value.month}/${value.year} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: value.toString(),
          keyboardType: TextInputType.number,
          onChanged: (val) {
            final intVal = int.tryParse(val);
            if (intVal != null) {
              onChanged(intVal);
            }
          },
          decoration: InputDecoration(
            labelText: label,
            helperText: helperText,
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
        ),
      ],
    );
  }
}
