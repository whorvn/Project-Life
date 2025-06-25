import 'package:flutter/material.dart';

class TimelineStep extends StatefulWidget {
  final Map<String, dynamic> initialData;
  final Function(Map<String, dynamic>) onDataChanged;

  const TimelineStep({
    super.key,
    required this.initialData,
    required this.onDataChanged,
  });

  @override
  State<TimelineStep> createState() => _TimelineStepState();
}

class _TimelineStepState extends State<TimelineStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _prizesController;
  late TextEditingController _rulesController;
  late TextEditingController _requirementsController;
  late TextEditingController _judgingCriteriaController;
  
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    
    _prizesController = TextEditingController(
      text: widget.initialData['prizes'] ?? '',
    );
    _rulesController = TextEditingController(
      text: widget.initialData['rules'] ?? '',
    );
    _requirementsController = TextEditingController(
      text: widget.initialData['requirements'] ?? '',
    );
    _judgingCriteriaController = TextEditingController(
      text: widget.initialData['judging_criteria'] ?? '',
    );

    // Parse initial dates if available
    if (widget.initialData['start_date'] != null) {
      _startDate = DateTime.parse(widget.initialData['start_date']);
      _startTime = TimeOfDay.fromDateTime(_startDate!);
    }
    if (widget.initialData['end_date'] != null) {
      _endDate = DateTime.parse(widget.initialData['end_date']);
      _endTime = TimeOfDay.fromDateTime(_endDate!);
    }

    // Listen to changes
    _prizesController.addListener(_updateData);
    _rulesController.addListener(_updateData);
    _requirementsController.addListener(_updateData);
    _judgingCriteriaController.addListener(_updateData);
  }

  @override
  void dispose() {
    _prizesController.dispose();
    _rulesController.dispose();
    _requirementsController.dispose();
    _judgingCriteriaController.dispose();
    super.dispose();
  }

  void _updateData() {
    DateTime? startDateTime;
    DateTime? endDateTime;

    if (_startDate != null && _startTime != null) {
      startDateTime = DateTime(
        _startDate!.year,
        _startDate!.month,
        _startDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
    }

    if (_endDate != null && _endTime != null) {
      endDateTime = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }

    widget.onDataChanged({
      'start_date': startDateTime?.toIso8601String(),
      'end_date': endDateTime?.toIso8601String(),
      'prizes': _prizesController.text,
      'rules': _rulesController.text,
      'requirements': _requirementsController.text,
      'judging_criteria': _judgingCriteriaController.text,
    });
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _startDate = date;
      });
      _updateData();
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _endDate = date;
      });
      _updateData();
    }
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _startTime = time;
      });
      _updateData();
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      setState(() {
        _endTime = time;
      });
      _updateData();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select time';
    return time.format(context);
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
                'Timeline & Details',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up the timeline and detailed information for your hackathon',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              // Start Date & Time
              Text(
                'Event Timeline',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectStartDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_formatDate(_startDate)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectStartTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(_formatTime(_startTime)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Start Date & Time *',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              
              // End Date & Time
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectEndDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_formatDate(_endDate)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectEndTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(_formatTime(_endTime)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'End Date & Time *',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              // Prizes
              Text(
                'Event Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _prizesController,
                decoration: const InputDecoration(
                  labelText: 'Prizes',
                  hintText: 'List the prizes and rewards...',
                  prefixIcon: Icon(Icons.emoji_events),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              
              // Rules
              TextFormField(
                controller: _rulesController,
                decoration: const InputDecoration(
                  labelText: 'Rules & Guidelines',
                  hintText: 'Specify the rules participants must follow...',
                  prefixIcon: Icon(Icons.rule),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              
              // Requirements
              TextFormField(
                controller: _requirementsController,
                decoration: const InputDecoration(
                  labelText: 'Requirements',
                  hintText: 'What participants need to bring or prepare...',
                  prefixIcon: Icon(Icons.checklist),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              
              // Judging Criteria
              TextFormField(
                controller: _judgingCriteriaController,
                decoration: const InputDecoration(
                  labelText: 'Judging Criteria',
                  hintText: 'How projects will be evaluated...',
                  prefixIcon: Icon(Icons.gavel),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
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
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Timeline Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Most hackathons run for 24-48 hours\n'
                      '• Include buffer time for setup and presentations\n'
                      '• Clear rules help avoid conflicts during the event\n'
                      '• Detailed judging criteria ensure fair evaluation',
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
