// lib/pages/location_select.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/pages/height_input.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:test_app/pages/user_details.dart';
import 'package:test_app/shared_preferences.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  _LocationSelectionPageState createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  String? selectedState;
  String? selectedCountry;
  String? selectedCountryId;
  String? selectedStateId;
  bool _isButtonEnabled = false;

  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

Future<void> _loadSavedLocation() async {
final savedCountryId = await PersistentData.getCountryId();
    final savedCountryName = await PersistentData.getCountryName();
    final savedStateId = await PersistentData.getStateId();
    final savedStateName = await PersistentData.getStateName();
   
if (savedCountryId != null && savedCountryName != null) {
      setState(() {
        selectedCountryId = savedCountryId;
        selectedCountry = savedCountryName;
      });

      if (savedCountryName == "India") {
        await _fetchStates(savedCountryId, savedCountryName);

        if (savedStateId != null && savedStateName != null) {
          setState(() {
            selectedStateId = savedStateId;
            selectedState = savedStateName;
          });
        }
      }
    }
    _checkFormValid();
  }

 Future<void> _fetchCountries() async {
    final url = Uri.parse("http://192.168.1.30:8000/public/countries");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Map countries safely
        final mappedCountries =
            data.map((e) {
              return {
                "id": e["id"] ?? "", // Ensure id is never null
                "name": e["name"] ?? "",
              };
            }).toList();

        if (!mounted) return;

        setState(() {
          countries = mappedCountries;
        });

        // Load saved location only after countries are fetched
        await _loadSavedLocation();
      } else {
        print("❌ Failed to load countries: ${response.statusCode}");
        if (!mounted) return;
        setState(() {
          countries = [];
        });
      }
    } catch (e) {
      print("🔥 Exception while fetching countries: $e");
      if (!mounted) return;
      setState(() {
        countries = [];
      });
    }
  }


  Future<void> _fetchStates(String countryId, String countryName) async {
    if (countryName != "India") {
      setState(() {
        states = [];
        selectedState = null;
        selectedStateId = null;
      });
      return;
    }

    final url = Uri.parse("http://192.168.1.30:8000/public/countries/$countryId/states");
    final response = await http.get(url);
print("🌍 Fetching countries from: $url");
    print("📡 Response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        states = data.map((e) => {
              "id": e["id"],
              "name": e["name"],
            }).toList();
      });
    } else {
      setState(() {
        states = [];
      });
    }
  }

  void _checkFormValid() {
    setState(() {
      if (selectedCountry == "India") {
        _isButtonEnabled = selectedState != null && selectedStateId != null;
      } else {
        _isButtonEnabled = selectedCountry != null && selectedCountryId != null;
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
            // Back + Progress bar
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 28, right: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserDetailsPage()),
                      );
                    },
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.30,
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

            // Country Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF7F7F7F)),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        value: selectedCountry,
                        hint: const Text("Select Country"),
                        items: countries.map((c) {
                          return DropdownMenuItem<String>(
                            value: c["name"],
                            child: Text(c["name"]),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          final selected = countries.firstWhere((c) => c["name"] == value);
                          setState(() {
                            selectedCountry = selected["name"];
                            selectedCountryId = selected["id"];
                            selectedState = null;
                            selectedStateId = null;
                          });
                          await _fetchStates(selectedCountryId!, selectedCountry!);
                          _checkFormValid();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // State Dropdown (only for India)
            if (selectedCountry == "India")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "State",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF7F7F7F)),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          value: selectedState,
                          hint: const Text("Select State"),
                          items: states.map((s) {
                            return DropdownMenuItem<String>(
                              value: s["name"],
                              child: Text(s["name"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selected = states.firstWhere((s) => s["name"] == value);
                            setState(() {
                              selectedState = selected["name"];
                              selectedStateId = selected["id"];
                            });
                            _checkFormValid();
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
                      ? () async {
                          // Save location data with IDs
                         await PersistentData.saveLocation(
                              countryId: selectedCountryId!,
                              country: selectedCountry!, // ✅ Save name too
                              stateId:
                                  selectedCountry == "India"
                                      ? selectedStateId
                                      : null,
                              state:
                                  selectedCountry == "India"
                                      ? selectedState
                                      : null,
                            );

                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HeightInputPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? const Color(0xFF0C0C0C) : const Color(0xFF7F8180),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}