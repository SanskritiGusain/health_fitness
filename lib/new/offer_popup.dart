import 'package:flutter/material.dart';

class OfferPopup {
  static void showOfferDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/fitness_banner.jpg", // Replace with your image
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "70% OFF",
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "LIMITED TIME OFFER",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Keep progressing with unlimited workouts, diet guides & health insights",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.chat, color: Colors.teal),
                        title: Text("Unlimited Chat with AI Coach"),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.teal),
                        title: Text("Personalized plans – Modified just for you"),
                      ),
                      ListTile(
                        leading: Icon(Icons.public, color: Colors.teal),
                        title: Text("Diet According to Your Geographical Location"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.pop(context); 
                      // Navigate to upgrade page here
                    },
                    child: const Text("Upgrade Now"),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Not Now"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
