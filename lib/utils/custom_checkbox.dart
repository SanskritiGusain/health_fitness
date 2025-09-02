import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomSvgCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: SvgPicture.asset(
        value
            ? "assets/icons_update/checkbox_checked.svg"
            : "assets/icons_update/checkbox-unchecked.svg",
        width: 20,
        height: 20,
    
      ),
    );
  }
}