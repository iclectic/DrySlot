import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../weather_core/domain/weather_models.dart';

class CommuteWindowsSheet extends StatefulWidget {
  const CommuteWindowsSheet({super.key, required this.initialWindows});

  final List<SavedCommuteWindow> initialWindows;

  @override
  State<CommuteWindowsSheet> createState() => _CommuteWindowsSheetState();
}

class _CommuteWindowsSheetState extends State<CommuteWindowsSheet> {
  late List<SavedCommuteWindow> _windows;

  @override
  void initState() {
    super.initState();
    _windows = List<SavedCommuteWindow>.from(widget.initialWindows);
  }

  Future<void> _editWindow([SavedCommuteWindow? existing]) async {
    final result = await showModalBottomSheet<SavedCommuteWindow>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CommuteWindowEditorSheet(initialWindow: existing);
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      final index = _windows.indexWhere((window) => window.id == result.id);
      if (index == -1) {
        _windows = <SavedCommuteWindow>[..._windows, result];
      } else {
        _windows = <SavedCommuteWindow>[
          ..._windows.take(index),
          result,
          ..._windows.skip(index + 1),
        ];
      }
      _windows.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.48,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return AppSheetFrame(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              const AppSheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Favourite routines',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save the routines you care about and Dry Slots will summarise them each day.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.tonalIcon(
                          onPressed: _editWindow,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add routine'),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _windows = SavedCommuteWindow.defaults;
                            });
                          },
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Reset examples'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _windows.length,
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final window = _windows[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: appSheetSurfaceFill(context),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: appSheetSurfaceBorder(context)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () => _editWindow(window),
                              borderRadius: BorderRadius.circular(18),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color: appSheetSurfaceFill(
                                        context,
                                        strong: true,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.schedule_rounded,
                                      color: AppPalette.sky,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          window.label,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatWindowMinutes(
                                            window.startMinutes,
                                            window.endMinutes,
                                          ),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _windows = _windows
                                    .where((item) => item.id != window.id)
                                    .toList(growable: false);
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_windows),
                    child: const Text('Save routines'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommuteWindowEditorSheet extends StatefulWidget {
  const CommuteWindowEditorSheet({super.key, this.initialWindow});

  final SavedCommuteWindow? initialWindow;

  @override
  State<CommuteWindowEditorSheet> createState() =>
      _CommuteWindowEditorSheetState();
}

class _CommuteWindowEditorSheetState extends State<CommuteWindowEditorSheet> {
  late final TextEditingController _labelController;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialWindow;
    _labelController = TextEditingController(text: initial?.label ?? '');
    _startTime = _minutesToTimeOfDay(initial?.startMinutes ?? 8 * 60);
    _endTime = _minutesToTimeOfDay(initial?.endMinutes ?? 9 * 60);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  void _save() {
    final label = _labelController.text.trim();
    if (label.isEmpty) {
      return;
    }
    final window = SavedCommuteWindow(
      id:
          widget.initialWindow?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      label: label,
      startMinutes: _timeOfDayToMinutes(_startTime),
      endMinutes: _timeOfDayToMinutes(_endTime),
    );
    Navigator.of(context).pop(window);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: AppSheetFrame(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.initialWindow == null
                    ? 'Add favourite routine'
                    : 'Edit favourite routine',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _labelController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Label',
                  hintText: 'Evening jog',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _TimeField(
                      label: 'Start',
                      value: _formatTimeOfDay(_startTime),
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeField(
                      label: 'End',
                      value: _formatTimeOfDay(_endTime),
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Save window'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label time, $value',
      hint: 'Double tap to choose a time',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: appSheetSurfaceFill(context, strong: true),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: appSheetSurfaceBorder(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 6),
              Text(value, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatWindowMinutes(int startMinutes, int endMinutes) {
  final start = _minutesToTimeOfDay(startMinutes);
  final end = _minutesToTimeOfDay(endMinutes);
  return '${_formatTimeOfDay(start)} to ${_formatTimeOfDay(end)}';
}

TimeOfDay _minutesToTimeOfDay(int totalMinutes) {
  final normalized = ((totalMinutes % (24 * 60)) + (24 * 60)) % (24 * 60);
  return TimeOfDay(hour: normalized ~/ 60, minute: normalized % 60);
}

int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hour == 0
      ? 12
      : time.hour > 12
      ? time.hour - 12
      : time.hour;
  final suffix = time.hour >= 12 ? 'pm' : 'am';
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $suffix';
}
