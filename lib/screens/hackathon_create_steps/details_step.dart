import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme_config.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class DetailsStep extends StatefulWidget {
  final Map<String, dynamic> data;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const DetailsStep({
    Key? key,
    required this.data,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  State<DetailsStep> createState() => _DetailsStepState();
}

class _DetailsStepState extends State<DetailsStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _maxParticipantsController;
  late TextEditingController _requirementsController;
  late TextEditingController _prizesController;
  late TextEditingController _rulesController;
  late TextEditingController _tagController;
  List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _maxParticipantsController = TextEditingController(
      text: widget.data['max_participants']?.toString() ?? '',
    );
    _requirementsController = TextEditingController(text: widget.data['requirements']);
    _prizesController = TextEditingController(text: widget.data['prizes']);
    _rulesController = TextEditingController(text: widget.data['rules']);
    _tagController = TextEditingController();
    _tags = List<String>.from(widget.data['tags'] ?? []);
  }

  @override
  void dispose() {
    _maxParticipantsController.dispose();
    _requirementsController.dispose();
    _prizesController.dispose();
    _rulesController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      widget.data['max_participants'] = _maxParticipantsController.text.isNotEmpty
          ? int.tryParse(_maxParticipantsController.text)
          : null;
      widget.data['requirements'] = _requirementsController.text.trim();
      widget.data['prizes'] = _prizesController.text.trim();
      widget.data['rules'] = _rulesController.text.trim();
      widget.data['tags'] = _tags;
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Details',
              style: ThemeConfig.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add more details to make your hackathon attractive.',
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
                    CustomTextField(
                      controller: _maxParticipantsController,
                      label: 'Maximum Participants (Optional)',
                      hintText: 'e.g., 100',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _requirementsController,
                      label: 'Requirements',
                      hintText: 'What skills or tools are needed?',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter requirements';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _prizesController,
                      label: 'Prizes',
                      hintText: 'What can participants win?',
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter prize information';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _rulesController,
                      label: 'Rules & Guidelines',
                      hintText: 'Important rules participants should know',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter rules and guidelines';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tags section
                    Text(
                      'Tags',
                      style: ThemeConfig.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _tagController,
                            label: 'Add Tag',
                            hintText: 'e.g., AI, Web Development, Mobile',
                            onChanged: (value) {
                              if (value.endsWith(',') || value.endsWith(' ')) {
                                _addTag();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomButton(
                          text: 'Add',
                          onPressed: _addTag,
                          width: 80,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tags display
                    if (_tags.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ThemeConfig.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: ThemeConfig.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tag,
                                  style: ThemeConfig.bodySmall.copyWith(
                                    color: ThemeConfig.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () => _removeTag(tag),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: ThemeConfig.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Text(
                      'Tip: Add relevant tags to help participants find your hackathon',
                      style: ThemeConfig.bodySmall.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
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
      ),
    );
  }
}
