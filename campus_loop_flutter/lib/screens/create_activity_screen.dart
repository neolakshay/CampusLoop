import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';

import '../client.dart';
import '../state/activity_state.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';

class CreateActivityScreen extends StatefulWidget {
  final ActivityState state;

  const CreateActivityScreen({
    super.key,
    required this.state,
  });

  @override
  State<CreateActivityScreen> createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  ActivityKind _selectedKind = ActivityKind.studySession;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  DateTime _startDate = DateTime.now().add(const Duration(days: 1, hours: 2));
  TimeOfDay _startTime = const TimeOfDay(hour: 14, minute: 0);

  bool _hasEndTime = false;
  DateTime _endDate = DateTime.now().add(
    const Duration(days: 1, hours: 3, minutes: 30),
  );
  TimeOfDay _endTime = const TimeOfDay(hour: 15, minute: 30);

  bool _hasCapacityLimit = false;
  bool _isSubmitting = false;

  final List<String> _locationSuggestions = [
    'Main Library - 2nd Floor',
    'Student Union Plaza',
    'Science & Tech Quad',
    'Campus Center Cafe',
    'Engineering Hall 304',
    'Online via Zoom',
  ];

  @override
  void initState() {
    super.initState();
    _organizerController.text = 'Student Host';
    _loadOrganizerName();
  }

  Future<void> _loadOrganizerName() async {
    try {
      final profile = await client.modules.serverpod_auth_core.userProfileInfo
          .get();
      final userName = profile.userName?.trim();
      final email = profile.email?.trim();
      final name = userName != null && userName.isNotEmpty
          ? userName
          : email != null && email.isNotEmpty
          ? email.split('@').first
          : null;

      if (mounted &&
          name != null &&
          _organizerController.text == 'Student Host') {
        _organizerController.text = name;
      }
    } catch (_) {
      // Keep the form usable if an optional profile lookup is unavailable.
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _organizerController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _pickStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => _startDate = pickedDate);
    }
  }

  Future<void> _pickStartTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (pickedTime != null) {
      setState(() => _startTime = pickedTime);
    }
  }

  Future<void> _pickEndDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate.isAfter(_startDate) ? _endDate : _startDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      setState(() => _endDate = pickedDate);
    }
  }

  Future<void> _pickEndTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (pickedTime != null) {
      setState(() => _endTime = pickedTime);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final startsAt = _combineDateTime(_startDate, _startTime).toUtc();
    final now = DateTime.now().toUtc();
    if (!startsAt.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Start time must be in the future.'),
          backgroundColor: AppColors.cancelled,
        ),
      );
      return;
    }

    DateTime? endsAt;
    if (_hasEndTime) {
      endsAt = _combineDateTime(_endDate, _endTime).toUtc();
      if (!endsAt.isAfter(startsAt)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after the start time.'),
            backgroundColor: AppColors.cancelled,
          ),
        );
        return;
      }
    }

    int? capacity;
    if (_hasCapacityLimit) {
      capacity = int.tryParse(_capacityController.text.trim());
      if (capacity == null || capacity < 2 || capacity > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Capacity must be between 2 and 100 attendees.'),
            backgroundColor: AppColors.cancelled,
          ),
        );
        return;
      }
    }

    final request = CreateActivityRequest(
      kind: _selectedKind,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      topic: _topicController.text.trim().isEmpty
          ? null
          : _topicController.text.trim(),
      startsAt: startsAt,
      endsAt: endsAt,
      location: _locationController.text.trim(),
      capacity: capacity,
      organizerName: _organizerController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      final details = await widget.state.createActivity(request);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created "${details.activity.title}" successfully!'),
            backgroundColor: AppColors.active,
          ),
        );
        Navigator.of(context).pop(details);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ActivityState.parseErrorMessage(e)),
            backgroundColor: AppColors.cancelled,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isStudy = _selectedKind == ActivityKind.studySession;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Campus Activity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: [
            // Kind Selector
            Text(
              'Activity Type',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildKindSelectorCard(
                    kind: ActivityKind.studySession,
                    title: 'Study Session',
                    subtitle:
                        'Peer-led group study, exam prep, problem solving',
                    icon: Icons.school_rounded,
                    isSelected: isStudy,
                    color: AppColors.studyPrimary,
                    bg: AppColors.studyBackground,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKindSelectorCard(
                    kind: ActivityKind.event,
                    title: 'Campus Event',
                    subtitle: 'Social, club meeting, hackathon, mixer',
                    icon: Icons.event_rounded,
                    isSelected: !isStudy,
                    color: AppColors.eventPrimary,
                    bg: AppColors.eventBackground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            TextFormField(
              controller: _titleController,
              maxLength: 80,
              decoration: InputDecoration(
                labelText: 'Activity Title *',
                hintText: isStudy
                    ? 'e.g. CS 101 Midterm Problem Solving'
                    : 'e.g. ACM Spring Hackathon & Mixer',
                helperText: 'Between 3 and 80 characters',
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.length < 3 || text.length > 80) {
                  return 'Title must be between 3 and 80 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Topic (Required for Study Session, optional for Event)
            TextFormField(
              controller: _topicController,
              maxLength: 40,
              decoration: InputDecoration(
                labelText: isStudy
                    ? 'Course or Topic *'
                    : 'Topic or Category (Optional)',
                hintText: isStudy
                    ? 'e.g. Calculus I, Data Structures, CHEM 102'
                    : 'e.g. Coding, Gaming, Careers',
                helperText: isStudy
                    ? 'Required for study sessions (max 40 chars)'
                    : 'Optional category tag (max 40 chars)',
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (isStudy && text.isEmpty) {
                  return 'A study session needs a course or topic';
                }
                if (text.length > 40) {
                  return 'Topic must be 40 characters or fewer';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLength: 500,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText:
                    'Share what you will cover, prerequisites, agenda, or materials to bring...',
                helperText: 'Between 10 and 500 characters',
                alignLabelWithHint: true,
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.length < 10 || text.length > 500) {
                  return 'Description must be between 10 and 500 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Start Date & Time
            Text(
              'Date & Time',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Starts:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: _pickStartDate,
                        child: Text(
                          DateFormatter.formatDateTime(
                            _startDate,
                          ).split('•').first.trim(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _pickStartTime,
                        child: Text(_startTime.format(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _hasEndTime,
                        onChanged: (val) =>
                            setState(() => _hasEndTime = val ?? false),
                      ),
                      const Text('Specify End Time'),
                      const Spacer(),
                      if (_hasEndTime) ...[
                        OutlinedButton(
                          onPressed: _pickEndDate,
                          child: Text(
                            DateFormatter.formatDateTime(
                              _endDate,
                            ).split('•').first.trim(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _pickEndTime,
                          child: Text(_endTime.format(context)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Location
            TextFormField(
              controller: _locationController,
              maxLength: 100,
              decoration: const InputDecoration(
                labelText: 'Location on Campus *',
                hintText: 'e.g. Science Library Room 204 or Student Center',
                helperText: 'Between 2 and 100 characters',
                prefixIcon: Icon(Icons.location_on_outlined, size: 20),
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.length < 2 || text.length > 100) {
                  return 'Location must be between 2 and 100 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _locationSuggestions.map((loc) {
                return ActionChip(
                  label: Text(loc, style: const TextStyle(fontSize: 11)),
                  onPressed: () =>
                      setState(() => _locationController.text = loc),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Capacity
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 20,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Limit Attendance Capacity',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Switch(
                        value: _hasCapacityLimit,
                        onChanged: (val) {
                          setState(() {
                            _hasCapacityLimit = val;
                            if (val && _capacityController.text.isEmpty) {
                              _capacityController.text = '10';
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  if (_hasCapacityLimit) ...[
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max Capacity (2 - 100)',
                        hintText: 'e.g. 15',
                        helperText: 'Includes the organizer in the count',
                      ),
                      validator: (v) {
                        if (!_hasCapacityLimit) return null;
                        final num = int.tryParse(v?.trim() ?? '');
                        if (num == null || num < 2 || num > 100) {
                          return 'Capacity must be between 2 and 100';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Organizer Display Name
            TextFormField(
              controller: _organizerController,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Organizer Display Name *',
                hintText: 'e.g. Sarah K. or Peer Tutor Alex',
                helperText: 'Your name as shown to fellow students',
                prefixIcon: Icon(Icons.badge_outlined, size: 20),
              ),
              validator: (v) {
                final text = v?.trim() ?? '';
                if (text.length < 2 || text.length > 40) {
                  return 'Name must be between 2 and 40 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _submitForm,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.rocket_launch_rounded, size: 20),
              label: Text(
                _isSubmitting
                    ? 'Publishing Activity...'
                    : 'Publish ${isStudy ? 'Study Session' : 'Campus Event'}',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKindSelectorCard({
    required ActivityKind kind,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required Color bg,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => setState(() => _selectedKind = kind),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? color.withValues(alpha: 0.15) : bg)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? color : AppColors.lightTextSecondary,
                ),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 18, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isSelected ? color : null,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
