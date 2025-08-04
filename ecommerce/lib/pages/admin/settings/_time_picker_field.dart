import 'package:flutter/material.dart';

class TimePickerField extends StatefulWidget {
  final String label;
  const TimePickerField({required this.label, super.key});

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;

  void _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextField(
        readOnly: true,
        onTap: _pickTime,
        controller: TextEditingController(
          text: _selectedTime != null ? _selectedTime!.format(context) : '',
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(),
          isDense: true,
          suffixIcon: Icon(Icons.access_time),
        ),
      ),
    );
  }
}
