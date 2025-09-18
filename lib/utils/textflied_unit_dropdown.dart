import 'package:flutter/material.dart';

class CustomInputWithDropdown extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomInputWithDropdown({
    super.key,
    required this.controller,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFC9C9C9),
                  fontWeight: FontWeight.w500,
                ),
                filled: true,
                fillColor: Colors.white,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),

          // 🔹 Vertical Divider
          Container(
            width: 1,
            height: 42,
            color: const Color(0xFFDDE5F0),
            margin: const EdgeInsets.symmetric(horizontal: 4),
          ),

          // 🔹 Dropdown
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButton<String>(
              value: value,
              underline: const SizedBox(),
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFFC9C9C9),
                size: 20,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF222326),
                fontWeight: FontWeight.w500,
              ),
              items: items
                  .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
