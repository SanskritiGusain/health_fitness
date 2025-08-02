import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/utils/custom_date_picker.dart';
import 'package:test_app/utils/custom_dropdown.dart';

class MenstrualCycleScreen extends StatefulWidget {
  const MenstrualCycleScreen({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleScreen> createState() => _MenstrualCycleScreenState();
}

class _MenstrualCycleScreenState extends State<MenstrualCycleScreen> {
  DateTime? lastPeriodDate;
  DateTime? nextPeriodDate;
  int cycleLength = 28;
  int periodLength = 5;
  DateTime selectedDate = DateTime.now();

  String selectedCycleRegularity = 'Yes';
  String selectedCondition = 'PCOS';
  String selectedMedicine = 'Neurofenix';

  // Make these static const to avoid recreating lists
  static const List<String> yesNoOptions = ['Yes', 'No'];
  static const List<String> medicalConditions = ['PCOS', 'PID', 'Fibroids', 'None'];
  static const List<String> medicineOptions = ['Neurofenix', 'Iron', 'Ibuprofen', 'None'];

  late TextEditingController periodDurationController;
  late TextEditingController cycleLengthController;

  String get displayDateText => DateFormat('MMM').format(selectedDate);

  @override
  void initState() {
    super.initState();
    lastPeriodDate = DateTime.now().subtract(const Duration(days: 15));
    periodDurationController = TextEditingController(text: periodLength.toString());
    cycleLengthController = TextEditingController(text: cycleLength.toString());
    _calculateNextPeriod();
  }

  @override
  void dispose() {
    periodDurationController.dispose();
    cycleLengthController.dispose();
    super.dispose();
  }

  void _calculateNextPeriod() {
    if (lastPeriodDate != null) {
      nextPeriodDate = lastPeriodDate!.add(Duration(days: cycleLength));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isLastPeriod) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          initialDate: isLastPeriod ? lastPeriodDate : nextPeriodDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isLastPeriod) {
          lastPeriodDate = picked;
          _calculateNextPeriod();
        } else {
          nextPeriodDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void _navigateToPreviousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
    });
  }

  void _navigateToNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
    });
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return CustomDatePicker(
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: _buildDateSelector(),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // Add functionality
              },
              child: const Text(
                '+ Add',
                style: TextStyle(
                  color: Color.fromARGB(255, 8, 167, 74),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Menstrual Cycle',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),

              // Last Period
              const Text(
                'Last Period',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      label: 'Start Date',
                      date: lastPeriodDate,
                      onTap: () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      label: 'End Date',
                      date: nextPeriodDate,
                      onTap: () => _selectDate(context, false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                'Cycle Insight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildEditableField(
                      label: 'Average period duration',
                      controller: periodDurationController,
                      suffix: 'Days',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final newValue = int.tryParse(value) ?? 5;
                          if (newValue != periodLength) {
                            setState(() {
                              periodLength = newValue;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildEditableField(
                      label: 'Average cycle length',
                      controller: cycleLengthController,
                      suffix: 'Days',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          final newValue = int.tryParse(value) ?? 28;
                          if (newValue != cycleLength) {
                            setState(() {
                              cycleLength = newValue;
                              _calculateNextPeriod();
                            });
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _buildCustomDropdownField(
                      label: 'Is your cycle regular',
                      value: selectedCycleRegularity,
                      options: yesNoOptions,
                      onChanged: (val) {
                        if (val != null && val != selectedCycleRegularity) {
                          setState(() => selectedCycleRegularity = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildCustomDropdownField(
                      label: 'medical condition',
                      value: selectedCondition,
                      options: medicalConditions,
                      onChanged: (val) {
                        if (val != null && val != selectedCondition) {
                          setState(() => selectedCondition = val);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildCustomDropdownField(
                label: 'Do you take any medicines',
                value: selectedMedicine,
                options: medicineOptions,
                onChanged: (val) {
                  if (val != null && val != selectedMedicine) {
                    setState(() => selectedMedicine = val);
                  }
                },
              ),
              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildNavigationButton(
          icon: Icons.arrow_back_ios,
          onTap: _navigateToPreviousMonth,
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayDateText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 21, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildNavigationButton(
          icon: Icons.arrow_forward_ios,
          onTap: _navigateToNextMonth,
        ),
      ],
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 16, color: Colors.black),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: Colors.black),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatDate(date),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Text(
                suffix,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDropdownField({
    required String label,
    required String value,
    required List<String> options,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CustomDropdown(
          selectedValue: value,
          items: options,
          hintText: 'Select option',
          onChanged: onChanged,
          backgroundColor: Colors.white,
          borderColor: Colors.grey.shade300,
          textColor: Colors.black87,
          hintColor: Colors.black54,
          iconColor: Colors.black54,
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}