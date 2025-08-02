import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String? selectedValue;
  final List<String> items;
  final String hintText;
  final void Function(String?) onChanged;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    
    // Calculate if dropdown should appear above or below
    final double spaceBelow = screenHeight - offset.dy - size.height;
    final double spaceAbove = offset.dy;
    final bool showAbove = spaceBelow < 200 && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: showAbove ? offset.dy - 4 : offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: showAbove ? spaceAbove - 20 : spaceBelow - 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor ?? Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.items.map((item) {
                    return _buildDropdownItem(item);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String item) {
    final isSelected = item == widget.selectedValue;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          widget.onChanged(item);
          _closeDropdown();
        },
        child: Container(
          width: double.infinity,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey.shade100 : Colors.transparent,
          ),
          child: Text(
            item,
            style: widget.textStyle ?? TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: widget.textColor ?? Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _buttonKey,
        onTap: _toggleDropdown,
        child: Container(
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            border: Border.all(
              color: widget.borderColor ?? Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedValue ?? widget.hintText,
                  style: widget.selectedValue != null 
                      ? (widget.textStyle ?? TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: widget.textColor ?? Colors.black87,
                        ))
                      : (widget.hintStyle ?? TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: widget.hintColor ?? Colors.black54,
                        )),
                ),
              ),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 20,
                color: widget.iconColor ?? Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}