import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../models/hackathon.dart';
import '../widgets/loading_overlay.dart';

class HackathonEditScreen extends StatefulWidget {
  final Hackathon hackathon;

  const HackathonEditScreen({
    super.key,
    required this.hackathon,
  });

  @override
  State<HackathonEditScreen> createState() => _HackathonEditScreenState();
}

class _HackathonEditScreenState extends State<HackathonEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _selectedType;
  late TextEditingController _themeController;
  late DateTime _applicationStartDate;
  late DateTime _applicationEndDate;
  late DateTime _eventStartDate;
  late DateTime _eventEndDate;
  late TextEditingController _prizePoolController;
  late TextEditingController _rulesController;
  late int _minTeamSize;
  late int _maxTeamSize;
  late int _maxParticipants;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing hackathon data
    _nameController = TextEditingController(text: widget.hackathon.name);
    _descriptionController = TextEditingController(text: widget.hackathon.description);
    _selectedType = widget.hackathon.type ?? 'Hybrid';
    _themeController = TextEditingController(text: widget.hackathon.theme ?? '');
    _applicationStartDate = widget.hackathon.applicationStartDate ?? DateTime.now();
    _applicationEndDate = widget.hackathon.applicationEndDate ?? DateTime.now().add(const Duration(days: 14));
    _eventStartDate = widget.hackathon.startDate;
    _eventEndDate = widget.hackathon.endDate;
    _prizePoolController = TextEditingController(text: widget.hackathon.prizePool ?? '');
    _rulesController = TextEditingController(text: widget.hackathon.rules ?? '');
    _minTeamSize = 2; // Default values since these might not be in the model
    _maxTeamSize = widget.hackathon.maxTeamSize;
    _maxParticipants = widget.hackathon.maxParticipants ?? 100;
  }

  Future<void> _updateHackathon() async {
    try {
      final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
      
      final hackathonData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'theme': _themeController.text,
        'start_date': _eventStartDate.toIso8601String(),
        'end_date': _eventEndDate.toIso8601String(),
        'application_start_date': _applicationStartDate.toIso8601String(),
        'application_end_date': _applicationEndDate.toIso8601String(),
        'application_open': _applicationStartDate.toIso8601String(),
        'application_close': _applicationEndDate.toIso8601String(),
        'prize_pool': _prizePoolController.text,
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

      await hackathonProvider.updateHackathon(widget.hackathon.id, hackathonData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hackathon updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating hackathon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
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
              title: Text('Edit ${widget.hackathon.name}'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: _updateHackathon,
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // General Information Section
                  _buildSectionHeader('General Information'),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _nameController,
                    label: 'Hackathon Name *',
                    hint: 'e.g., CodeFest 2025',
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description *',
                    hint: 'Detailed overview of your hackathon...',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildDropdownField(
                    value: _selectedType,
                    label: 'Hackathon Type *',
                    items: ['Online', 'Offline', 'Hybrid'],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _themeController,
                    label: 'Theme or Focus Area',
                    hint: 'e.g., AI for Healthcare, Sustainable Tech',
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Event Details Section
                  _buildSectionHeader('Event Details'),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Application Period',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 16),
                  
                  Text(
                    'Event Period',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _prizePoolController,
                    label: 'Prize Pool Details',
                    hint: 'Describe awards and prize distribution...',
                    maxLines: 4,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Participant Settings Section
                  _buildSectionHeader('Participant Settings'),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _rulesController,
                    label: 'Hackathon Rules',
                    hint: 'Outline participation guidelines...',
                    maxLines: 6,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Team Size Requirements',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  _buildNumberField(
                    label: 'Maximum Participant Cap',
                    value: _maxParticipants,
                    onChanged: (value) {
                      setState(() {
                        _maxParticipants = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateHackathon,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Update Hackathon',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
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
    );
  }

  Widget _buildDateTimeField({
    required String label,
    required DateTime value,
    required Function(DateTime) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
  }) {
    return TextFormField(
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
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
