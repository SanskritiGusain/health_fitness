// lib/pages/user_details.dart
import 'package:flutter/material.dart';
import 'package:test_app/pages/location_select.dart';
import 'package:test_app/utils/persistent_data.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _selectedGender;

  bool _isButtonEnabled = false;

  final RegExp _nameRegExp = RegExp(r'^[a-zA-Z\s]+$');

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _ageController.addListener(_validateForm);
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final name = await PersistentData.getName();
    final age = await PersistentData.getAge();
    final gender = await PersistentData.getGender();

    setState(() {
      _nameController.text = name ?? '';
      _ageController.text = age?.toString() ?? '';
      _selectedGender = gender;
    });

    _validateForm();
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();

    final isValid = name.isNotEmpty &&
        _nameRegExp.hasMatch(name) &&
        name.length >= 3 &&
        name.length <= 20 &&
        age.isNotEmpty &&
        int.tryParse(age) != null &&
        int.parse(age) > 0 &&
        _selectedGender != null;

    setState(() {
      _isButtonEnabled = isValid;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Save user details using the utility class
      await PersistentData.saveUserDetails(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        gender: _selectedGender!,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LocationSelectionPage(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Stack(
          children: [
            // Progress Bar
            Positioned(
              top: 20,
              left: 6,
              right: 16,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF222326), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.15,
                        minHeight: 6,
                        backgroundColor: Color(0xFFECEFEE),
                        valueColor: AlwaysStoppedAnimation(Color(0xFF0C0C0C)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Title
            const Positioned(
              top: 100,
              left: 20,
              child: Text(
                "Details",
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF222326),
                ),
              ),
            ),

            // Form Fields
            Positioned(
              top: 160,
              left: 16,
              right: 16,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMenuItem("Name"),
                    _buildTextField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Name is required';
                        } else if (!_nameRegExp.hasMatch(value.trim())) {
                          return 'Only letters allowed';
                        } else if (value.trim().length < 3) {
                          return 'Min 3 characters';
                        } else if (value.trim().length > 20) {
                          return 'Max 20 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 26),

                    _buildMenuItem("Age"),
                    _buildTextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Age is required';
                        }
                        final age = int.tryParse(value.trim());
                        if (age == null || age <= 0 || age > 120) {
                          return 'Enter valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 26),

                    _buildMenuItem("Gender"),
                    _buildPopupGenderDropdown(),
                  ],
                ),
              ),
            ),

            // Next Button
            Positioned(
              bottom: 45,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? const Color(0xFF0C0C0C)
                        : const Color(0xFF7F8180),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'DM Sans',
          color: Color(0xFF7F7F7F),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) => _validateForm(),
      style: const TextStyle(
        fontFamily: 'DM Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF222326),
      ),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF9DA1A8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE5F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF222326)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPopupGenderDropdown() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () async {
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;
            final Offset position =
                button.localToGlobal(Offset.zero, ancestor: overlay);
            final Size size = button.size;

            final result = await showMenu<String>(
              context: context,
              position: RelativeRect.fromLTRB(
                position.dx,
                position.dy + size.height + 2,
                position.dx + size.width,
                0,
              ),
              items: [
                const PopupMenuItem(value: 'Male', child: Text('Male')),
                const PopupMenuItem(value: 'Female', child: Text('Female')),
                const PopupMenuItem(value: 'Other', child: Text('Other')),
              ],
              color: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Color(0xFFDDE5F0)),
              ),
              constraints: BoxConstraints.tightFor(width: size.width),
            );

            if (result != null) {
              setState(() {
                _selectedGender = result;
              });
              _validateForm();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDDE5F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedGender ?? 'Select Gender',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222326),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFF222326)),
              ],
            ),
          ),
        );
      },
    );
  }
}