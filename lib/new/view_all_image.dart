import 'package:flutter/material.dart';
import 'dart:io'; 

class ViewAllImagesPage extends StatelessWidget {
  final List<File> images;

  const ViewAllImagesPage({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Progress Images")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(images[index], fit: BoxFit.cover),
            );
          },
        ),
      ),
    );
  }
}
