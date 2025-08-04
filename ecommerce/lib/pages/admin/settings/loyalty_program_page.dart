import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Make sure that _TimePickerField is defined as a widget in _time_picker_field.dart and is exported properly.


class LoyaltyProgramPage extends StatefulWidget {
  const LoyaltyProgramPage({super.key});

  @override
  State<LoyaltyProgramPage> createState() => _LoyaltyProgramPageState();
}

class _LoyaltyProgramPageState extends State<LoyaltyProgramPage> {
  final _formKey = GlobalKey<FormState>();
  // Field controllers
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  TimeOfDay? _startTime;
  final _endDateController = TextEditingController();
  TimeOfDay? _endTime;
  final _messageController = TextEditingController();
  final _pointInCashController = TextEditingController();
  final _couponValueController = TextEditingController();
  String _couponType = 'Type 1';
  final _minValueController = TextEditingController();
  final _maxValueController = TextEditingController();
  String _discountType = 'Type A';
  final _usageTimesController = TextEditingController();
  final _nextNumberController = TextEditingController();
  final _cardPrefixController = TextEditingController();
  final _usageDaysController = TextEditingController();
  final _fromNumberController = TextEditingController();
  final _toNumberController = TextEditingController();
  bool _enabled = true;

  // For undo
  Map<String, dynamic>? _lastValues;
  // _showUndo is no longer needed; Snackbar will handle undo

  void _saveLastValues() {
    _lastValues = {
      'name': _nameController.text,
      'startDate': _startDateController.text,
      'startTime': _startTime,
      'endDate': _endDateController.text,
      'endTime': _endTime,
      'message': _messageController.text,
      'pointInCash': _pointInCashController.text,
      'couponValue': _couponValueController.text,
      'couponType': _couponType,
      'minValue': _minValueController.text,
      'maxValue': _maxValueController.text,
      'discountType': _discountType,
      'usageTimes': _usageTimesController.text,
      'nextNumber': _nextNumberController.text,
      'cardPrefix': _cardPrefixController.text,
      'usageDays': _usageDaysController.text,
      'fromNumber': _fromNumberController.text,
      'toNumber': _toNumberController.text,
      'enabled': _enabled,
    };
  }

  void _restoreLastValues() {
    if (_lastValues == null) return;
    _nameController.text = _lastValues!['name'] ?? '';
    _startDateController.text = _lastValues!['startDate'] ?? '';
    _startTime = _lastValues!['startTime'];
    _endDateController.text = _lastValues!['endDate'] ?? '';
    _endTime = _lastValues!['endTime'];
    _messageController.text = _lastValues!['message'] ?? '';
    _pointInCashController.text = _lastValues!['pointInCash'] ?? '';
    _couponValueController.text = _lastValues!['couponValue'] ?? '';
    _couponType = _lastValues!['couponType'] ?? 'Type 1';
    _minValueController.text = _lastValues!['minValue'] ?? '';
    _maxValueController.text = _lastValues!['maxValue'] ?? '';
    _discountType = _lastValues!['discountType'] ?? 'Type A';
    _usageTimesController.text = _lastValues!['usageTimes'] ?? '';
    _nextNumberController.text = _lastValues!['nextNumber'] ?? '';
    _cardPrefixController.text = _lastValues!['cardPrefix'] ?? '';
    _usageDaysController.text = _lastValues!['usageDays'] ?? '';
    _fromNumberController.text = _lastValues!['fromNumber'] ?? '';
    _toNumberController.text = _lastValues!['toNumber'] ?? '';
    _enabled = _lastValues!['enabled'] ?? true;
    setState(() {});
  }

  void _clearForm() {
    _saveLastValues();
    _nameController.clear();
    _startDateController.clear();
    _startTime = null;
    _endDateController.clear();
    _endTime = null;
    _messageController.clear();
    _pointInCashController.clear();
    _couponValueController.clear();
    _couponType = 'Type 1';
    _minValueController.clear();
    _maxValueController.clear();
    _discountType = 'Type A';
    _usageTimesController.clear();
    _nextNumberController.clear();
    _cardPrefixController.clear();
    _usageDaysController.clear();
    _fromNumberController.clear();
    _toNumberController.clear();
    _enabled = true;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Form cleared'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: _restoreLastValues,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  String? _timeValidator(TimeOfDay? value) {
    if (value == null) {
      return 'Required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = colorScheme.background;
    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Program')),
      body: Container(
        color: background,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Loyalty Card', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: [
                            _LoyaltyTextField(
                              label: 'Name',
                              controller: _nameController,
                              validator: _requiredValidator,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
                            ),
                            _LoyaltyTextField(
                              label: 'Start Date',
                              controller: _startDateController,
                              validator: _requiredValidator,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\/]'))],
                            ),
                            _TimePickerFormField(label: 'Start Time', value: _startTime, onChanged: (t) => setState(() => _startTime = t), validator: _timeValidator),
                            _LoyaltyTextField(
                              label: 'End Date',
                              controller: _endDateController,
                              validator: _requiredValidator,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\/]'))],
                            ),
                            _TimePickerFormField(label: 'End Time', value: _endTime, onChanged: (t) => setState(() => _endTime = t), validator: _timeValidator),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 520,
                          child: _LoyaltyTextField(
                            label: 'Message To Display',
                            maxLines: 2,
                            controller: _messageController,
                            validator: _requiredValidator,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 16),
                        const Text('Coupon Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 24,
                          runSpacing: 20,
                          children: [
                            _LoyaltyTextField(label: 'Point In Cash', controller: _pointInCashController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(label: 'Coupon Value', controller: _couponValueController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyDropdown(label: 'Coupon Type', items: const ['Type 1', 'Type 2'], value: _couponType, onChanged: (v) => setState(() => _couponType = v!),),
                            _LoyaltyTextField(label: 'Minimum Value', controller: _minValueController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(label: 'Max Value', controller: _maxValueController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyDropdown(label: 'Discount Type', items: const ['Type A', 'Type B'], value: _discountType, onChanged: (v) => setState(() => _discountType = v!),),
                            _LoyaltyTextField(label: 'Number of Usage times', controller: _usageTimesController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(label: 'Next Number', controller: _nextNumberController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(
                              label: 'Card Prefix',
                              controller: _cardPrefixController,
                              validator: _requiredValidator,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))],
                            ),
                            _LoyaltyTextField(label: 'Number of Usage Days', controller: _usageDaysController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(label: 'From Number', controller: _fromNumberController, validator: _requiredValidator, numberOnly: true),
                            _LoyaltyTextField(label: 'To Number', controller: _toNumberController, validator: _requiredValidator, numberOnly: true),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Checkbox(value: _enabled, onChanged: (v) => setState(() => _enabled = v ?? true)),
                            const Text('Enable'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                OutlinedButton(
                                  onPressed: _clearForm,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  child: const Text('CANCEL'),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate() && _startTime != null && _endTime != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved!')));
                                      _saveLastValues();
                                    } else {
                                      // Show error for time fields if not filled
                                      setState(() {});
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                  ),
                                  child: const Text('SAVE'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _messageController.dispose();
    _pointInCashController.dispose();
    _couponValueController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _usageTimesController.dispose();
    _nextNumberController.dispose();
    _cardPrefixController.dispose();
    _usageDaysController.dispose();
    _fromNumberController.dispose();
    _toNumberController.dispose();
    super.dispose();
  }
}

class _LoyaltyTextField extends StatelessWidget {
  final String label;
  final int? maxLines;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool numberOnly;
  final List<TextInputFormatter>? inputFormatters;
  const _LoyaltyTextField({required this.label, this.maxLines, this.controller, this.validator, this.numberOnly = false, this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        validator: validator,
        keyboardType: numberOnly ? TextInputType.number : null,
        inputFormatters: inputFormatters ?? (numberOnly ? [FilteringTextInputFormatter.digitsOnly] : null),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

class _LoyaltyDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final ValueChanged<String?>? onChanged;
  const _LoyaltyDropdown({required this.label, required this.items, required this.value, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

// Custom time picker form field for validation
class _TimePickerFormField extends FormField<TimeOfDay> {
  _TimePickerFormField({
    required String label,
    required TimeOfDay? value,
    required ValueChanged<TimeOfDay?> onChanged,
    super.validator,
  }) : super(
          initialValue: value,
          builder: (state) {
            return SizedBox(
              width: 250,
              child: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: state.context,
                    initialTime: value ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    onChanged(picked);
                    state.didChange(picked);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: const Icon(Icons.access_time),
                    errorText: state.errorText,
                  ),
                  child: Text(
                    value != null ? value.format(state.context) : '',
                    style: Theme.of(state.context).textTheme.bodyMedium,
                  ),
                ),
              ),
            );
          },
        );
}
