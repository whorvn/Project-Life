import 'package:flutter/material.dart';

class BasicInfoStep extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const BasicInfoStep({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<BasicInfoStep> createState() => _BasicInfoStepState();
}

class _BasicInfoStepState extends State<BasicInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _maxParticipantsController;
  late TextEditingController _maxTeamSizeController;
  String _selectedStatus = 'draft';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialData['title'] ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialData['description'] ?? '',
    );
    _maxParticipantsController = TextEditingController(
      text: widget.initialData['max_participants']?.toString() ?? '',
    );
    _maxTeamSizeController = TextEditingController(
      text: widget.initialData['max_team_size']?.toString() ?? '4',
    );
    _selectedStatus = widget.initialData['status'] ?? 'draft';

    // Listen to changes and update parent
    _titleController.addListener(_updateData);
    _descriptionController.addListener(_updateData);
    _maxParticipantsController.addListener(_updateData);
    _maxTeamSizeController.addListener(_updateData);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _maxParticipantsController.dispose();
    _maxTeamSizeController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.onDataChanged({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'max_participants': int.tryParse(_maxParticipantsController.text),
      'max_team_size': int.tryParse(_maxTeamSizeController.text) ?? 4,
      'status': _selectedStatus,
    });
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
                'Basic Information',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Let\'s start with the basic details of your hackathon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Hackathon Title *',
                  hintText: 'Enter an engaging title for your hackathon',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  hintText: 'Describe what your hackathon is about...',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Max Participants
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Participants',
                  hintText: 'Leave empty for unlimited',
                  prefixIcon: Icon(Icons.group),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final number = int.tryParse(value);
                    if (number == null || number <= 0) {
                      return 'Please enter a valid positive number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Max Team Size
              TextFormField(
                controller: _maxTeamSizeController,
                decoration: const InputDecoration(
                  labelText: 'Maximum Team Size *',
                  hintText: 'Recommended: 4-6 members',
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter maximum team size';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  if (number > 20) {
                    return 'Team size should not exceed 20 members';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Status
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status *',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'draft',
                    child: Text('Draft - Not visible to participants'),
                  ),
                  DropdownMenuItem(
                    value: 'upcoming',
                    child: Text('Upcoming - Visible, registration open'),
                  ),
                  DropdownMenuItem(
                    value: 'active',
                    child: Text('Active - Currently running'),
                  ),
                  DropdownMenuItem(
                    value: 'completed',
                    child: Text('Completed - Finished'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _updateData();
                  }
                },
              ),
              const SizedBox(height: 32),
              
              // Help text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Tips for a great hackathon',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Choose a clear, exciting title that reflects your theme\n'
                      '• Write a compelling description that motivates participation\n'
                      '• Consider your venue capacity when setting participant limits\n'
                      '• Teams of 4-6 work best for most hackathons',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
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
