import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 162,
                      child: Image.asset(
                        'assets/images/fruit_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Full-width white container
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    

                      // Quote text
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal:4),
                        child: Column(
                          children: [
                            Text(
                              'Success! Let’s Make Progress Every Day',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontSize: 20,
                             
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF222326),
                              ),
                            ),
                            SizedBox(height: 0),
                           
                          ],
                        ),
                      ),

                      // Circular illustration
                    Center(
  child: Container(
    width: MediaQuery.of(context).size.width * 0.85,
    height: 355,
    decoration: const BoxDecoration(
      color: Color(0xFFC8EDEA),
      shape: BoxShape.circle,
    ),
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
        top:-30, // Shift the image 20 pixels upward
          child: Image.asset(
            'assets/images/sucess_man.png',
            width: 255.23,
            height: 380,
            fit: BoxFit.cover,
          ),
        ),
      ],
    ),
  ),
),


                      const SizedBox(height: 0),
                           
                        Column(
                          children: [
                            Text(
                              '"You’ve taken the first step — now let your consistency turn this beginning into success.Your journey starts today!"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Merriweather',
                                fontSize: 12,
                                height: 1.3,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF7F7F7F),
                              ),
                            ),
                            SizedBox(height: 48),
                           
                          ],
                        ),
                      

                      // Allow Permission Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to next screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Go to Plans",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                    ],
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
