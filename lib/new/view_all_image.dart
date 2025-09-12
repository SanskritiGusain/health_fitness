import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/shared_preferences.dart';

class ViewAllImagesPage extends StatefulWidget {
  final DateTime userCreatedAt; // User's account creation date

  const ViewAllImagesPage({Key? key, required this.userCreatedAt})
      : super(key: key);

  @override
  State<ViewAllImagesPage> createState() => _ViewAllImagesPageState();
}

class _ViewAllImagesPageState extends State<ViewAllImagesPage> {
  List<Map<String, dynamic>> images = [];
  bool isLoading = true;

  final String baseUrl = 'http://192.168.1.35:8000';

  @override
  void initState() {
    super.initState();
    fetchImageList();
  }

  Future<void> fetchImageList() async {
    try {
      final token = await PersistentData.getAuthToken();
      if (token == null) {
        debugPrint("⚠️ No token found in SharedPreferences!");
        setState(() => isLoading = false);
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/list-images/'),
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final files = data['files'] as List<dynamic>;

        setState(() {
          images = files
              .map((f) => {
                    'filename': f['filename'],
                    'created_at': DateTime.parse(f['created_at']),
                  })
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load image list');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint(e.toString());
    }
  }

  Future<Uint8List> fetchImageBytes(String filename) async {
    final token = await PersistentData.getAuthToken();
    if (token == null) throw Exception("No token available");

    final response = await http.get(
      Uri.parse('$baseUrl/get-image/$filename'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image $filename');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 75);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final token = await PersistentData.getAuthToken();
      if (token == null) {
        debugPrint("⚠️ No token found, cannot upload");
        return;
      }

      final request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/upload-image/'));
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        fetchImageList(); // Refresh list after upload
      } else {
        debugPrint("Upload failed: ${response.statusCode}");
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  int calculateDayNumber(DateTime imageDate) {
    return imageDate.difference(widget.userCreatedAt).inDays + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Progress Images")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : images.isEmpty
              ? _buildEmptyState(context)
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final filename = images[index]['filename'];
                    final createdAt =
                        images[index]['created_at'] as DateTime;
                    final dayNumber = calculateDayNumber(createdAt);

                    return Column(
                      children: [
                        Expanded(
                          child: FutureBuilder<Uint8List>(
                            future: fetchImageBytes(filename),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Icon(Icons.broken_image));
                              } else {
                                return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Day $dayNumber',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
      // floatingActionButton: images.isNotEmpty
      //     ? FloatingActionButton(
      //         onPressed: _showImageSourceDialog,
      //         child: const Icon(Icons.add),
      //       )
      //     : null,
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              "assets/placeholder.png",
              height: 60,
              width: 60,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "No Photos Available",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showImageSourceDialog,
            child: const Text("Add Progress Image"),
          ),
        ],
      ),
    );
  }
}
