import 'package:flutter/material.dart';
import 'package:test_app/pages/height_input.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:test_app/pages/user_details.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});
  
  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  String? selectedState;
  String? selectedCountry;
  bool _isButtonEnabled = false;

  final List<String> states = [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal'
  ];

  final List<String> countries = [
    'India', 'United States', 'United Kingdom', 'Canada', 'Australia',
    'Germany', 'France', 'Japan', 'China', 'Brazil',
    'South Africa', 'Russia', 'Italy', 'Spain', 'Netherlands'
  ];

  void _checkFormValid() {
    setState(() {
      if (selectedCountry == 'India') {
        _isButtonEnabled = selectedState != null;
      } else {
        _isButtonEnabled = selectedCountry != null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 28, right: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,color: Colors.black,size: 28,),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserDetailsPage()),
                      );
                    },
                  ),

                  // Progress bar
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.50,
                        minHeight: 6,
                        backgroundColor: Color(0xFFECEFEE),
                        color: Color(0xFF0C0C0C),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),

            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Nationality',
                style: TextStyle(
                  fontFamily: 'Merriweather',
                  fontSize: 20,
                  color: Color(0xFF222326),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Country Label + Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7F7F7F),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedCountry,
                        hint: const Text('Select Country'),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.expand_more, color: Color(0xFF6B7280)),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 300,
                          width: MediaQuery.of(context).size.width - 16,
                          offset: const Offset(0, -2),
                          elevation: 0, // Remove shadow
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.fromBorderSide(
                              BorderSide(color: Color(0xFFE5E7EB), width: 1)
                            ),
                          ),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: MaterialStateProperty.all(4),
                            thumbVisibility: MaterialStateProperty.all(true),
                            thumbColor: MaterialStateProperty.all(const Color(0xFFE5E7EB)),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 48,
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem<String>(
                            value: country,
                            child: Text(
                              country,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF374151),
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                            selectedState = null;
                            _checkFormValid();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // State Label + Dropdown (only if India is selected)
            if (selectedCountry == 'India')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'State',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7F7F7F),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedState,
                          hint: const Text('Select State'),
                          iconStyleData: const IconStyleData(
                            icon: Icon(Icons.expand_more, color: Color(0xFF6B7280)),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            maxHeight: 300,
                            width: MediaQuery.of(context).size.width - 16,
                            offset: const Offset(0, -2),
                            elevation: 0, // Remove shadow
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              border: Border.fromBorderSide(
                                BorderSide(color: Color(0xFFE5E7EB), width: 1)
                              ),
                            ),
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(4),
                              thumbVisibility: MaterialStateProperty.all(true),
                              thumbColor: MaterialStateProperty.all(const Color(0xFFE5E7EB)),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 48,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: states.map((state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(
                                state,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF374151),
                                  fontFamily: 'DM Sans',
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedState = value;
                              _checkFormValid();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // Next Button
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 45),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HeightInputPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isButtonEnabled ? const Color(0xFF0C0C0C) : const Color(0xFF7F8180),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 16,
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
}