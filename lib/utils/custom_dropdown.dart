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
  final bool enableSearch;
  final double? maxHeight;

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
    this.enableSearch = false,
    this.maxHeight = 250,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with WidgetsBindingObserver {
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _buttonKey = GlobalKey();
  List<String> _filteredItems = [];
  late TextEditingController _textController;
  late FocusNode _focusNode;
  String _lastValidSelection = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeControllers();
    _filteredItems = List.from(widget.items);
    _lastValidSelection = widget.selectedValue ?? '';
  }

  void _initializeControllers() {
    _textController = TextEditingController(text: widget.selectedValue ?? '');
    _focusNode = FocusNode();

    if (widget.enableSearch) {
      _focusNode.addListener(_onFocusChange);
      _textController.addListener(_onTextChange);
    }
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items != oldWidget.items) {
      _filteredItems = List.from(widget.items);
      if (_isOpen) {
        _overlayEntry?.markNeedsBuild();
      }
    }

    if (widget.selectedValue != oldWidget.selectedValue) {
      _textController.text = widget.selectedValue ?? '';
      _lastValidSelection = widget.selectedValue ?? '';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _closeDropdown();
    _focusNode.removeListener(_onFocusChange);
    _textController.removeListener(_onTextChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _closeDropdown();
    }
  }

  void _onFocusChange() {
    if (!mounted) return;

    if (_focusNode.hasFocus && !_isOpen && widget.enableSearch) {
      if (_textController.text == _lastValidSelection) {
        _textController.clear();
      }
      _openDropdown();
    } else if (!_focusNode.hasFocus && _isOpen) {
      _handleFocusLost();
    }
  }

  void _handleFocusLost() {
    final currentText = _textController.text.trim();

    final exactMatch = widget.items.firstWhere(
      (item) => item.toLowerCase() == currentText.toLowerCase(),
      orElse: () => '',
    );

    if (exactMatch.isNotEmpty) {
      widget.onChanged(exactMatch);
      _textController.text = exactMatch;
      _lastValidSelection = exactMatch;
    } else {
      _textController.text = _lastValidSelection;
    }

    _closeDropdown();
  }

  void _onTextChange() {
    if (!mounted) return;

    if (widget.enableSearch) {
      final query = _textController.text;
      _filterItems(query);

      if (query.isNotEmpty && !_isOpen && _focusNode.hasFocus) {
        _openDropdown();
      }
    }
  }

  void _toggleDropdown() {
    if (!mounted) return;

    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isOpen || !mounted) return;

    if (_textController.text.isEmpty) {
      _filteredItems = List.from(widget.items);
    }

    _overlayEntry = _createOverlayEntry();

    final overlay = Overlay.of(context);
    overlay.insert(_overlayEntry!);

    setState(() {
      _isOpen = true;
    });
  }

  void _closeDropdown() {
    if (!_isOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  void _filterItems(String query) {
    if (!mounted) return;

    List<String> filteredItems;

    if (query.isEmpty) {
      filteredItems = List.from(widget.items);
    } else {
      final queryLower = query.toLowerCase();

      final startsWith =
          widget.items
              .where((item) => item.toLowerCase().startsWith(queryLower))
              .toList();

      final contains =
          widget.items
              .where(
                (item) =>
                    !item.toLowerCase().startsWith(queryLower) &&
                    item.toLowerCase().contains(queryLower),
              )
              .toList();

      filteredItems = [...startsWith, ...contains];
    }

    setState(() {
      _filteredItems = filteredItems;
    });

    if (_isOpen) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }

    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double spaceBelow = screenHeight - offset.dy - size.height - 8;
    final double spaceAbove = offset.dy - 8;
    final bool showAbove =
        spaceBelow < (widget.maxHeight ?? 250) && spaceAbove > spaceBelow;
    final double maxDropdownHeight =
        showAbove
            ? (spaceAbove - 20).clamp(100.0, widget.maxHeight ?? 250)
            : (spaceBelow - 20).clamp(100.0, widget.maxHeight ?? 250);

    double leftPosition = offset.dx;
    double dropdownWidth = size.width;

    if (leftPosition + dropdownWidth > screenWidth - 20) {
      leftPosition = screenWidth - dropdownWidth - 20;
    }
    if (leftPosition < 20) {
      leftPosition = 20;
      dropdownWidth = screenWidth - 40;
    }

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _handleOutsideTap,
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: leftPosition,
                top:
                    showAbove
                        ? offset.dy - maxDropdownHeight - 8
                        : offset.dy + size.height + 4,
                width: dropdownWidth,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  color: Colors.transparent,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: maxDropdownHeight,
                      minHeight: 50,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: widget.borderColor ?? const Color(0xFFE5E7EB),
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
                      child: _buildDropdownList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildDropdownList() {
    if (_filteredItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No countries found',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: _filteredItems.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _filteredItems[index];
        final isSelected = item == widget.selectedValue;
        final query = _textController.text.toLowerCase();

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _selectItem(item),
            child: Container(
              width: double.infinity,
              padding: widget.padding,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF0C0C0C).withOpacity(0.05)
                        : Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildHighlightedText(item, query, isSelected),
                  ),
                  if (isSelected)
                    const Icon(Icons.check, size: 16, color: Color(0xFF0C0C0C)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightedText(String text, String query, bool isSelected) {
    if (query.isEmpty) {
      return Text(
        text,
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color:
                  isSelected
                      ? const Color(0xFF0C0C0C)
                      : (widget.textColor ?? Colors.black87),
            ),
      );
    }

    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    final index = textLower.indexOf(queryLower);

    if (index == -1) {
      return Text(
        text,
        style:
            widget.textStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color:
                  isSelected
                      ? const Color(0xFF0C0C0C)
                      : (widget.textColor ?? Colors.black87),
            ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          if (index > 0)
            TextSpan(
              text: text.substring(0, index),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected
                        ? const Color(0xFF0C0C0C)
                        : (widget.textColor ?? Colors.black87),
              ),
            ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0C0C0C),
              backgroundColor: Color(0xFFFFEB3B),
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(
              text: text.substring(index + query.length),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color:
                    isSelected
                        ? const Color(0xFF0C0C0C)
                        : (widget.textColor ?? Colors.black87),
              ),
            ),
        ],
      ),
    );
  }

  void _selectItem(String item) {
    if (!mounted) return;

    widget.onChanged(item);
    _textController.text = item;
    _lastValidSelection = item;
    _closeDropdown();
    _focusNode.unfocus();
  }

  void _handleOutsideTap() {
    _focusNode.unfocus();
  }

  void _handleIconTap() {
    if (widget.enableSearch) {
      if (_isOpen) {
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    } else {
      _toggleDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        key: _buttonKey,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _isOpen
                    ? const Color(
                      0xFF222326,
                    ) // Focused border color like text field
                    : const Color(
                      0xFFDDE5F0,
                    ), // Normal border color like text field
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child:
                  widget.enableSearch
                      ? TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF222326),
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9DA1A8),
                            fontFamily: 'DM Sans',
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                      )
                      : GestureDetector(
                        onTap: widget.items.isNotEmpty ? _toggleDropdown : null,
                        child: Text(
                          widget.selectedValue ?? widget.hintText,
                          style:
                              widget.selectedValue != null
                                  ? const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF222326),
                                  )
                                  : const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'DM Sans',
                                    color: Color(0xFF9DA1A8),
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
            ),
            GestureDetector(
              onTap: _handleIconTap,
              child: Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xFF222326),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
