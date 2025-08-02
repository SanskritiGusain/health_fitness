// import 'package:flutter/material.dart';
// import 'tools/tools_screen.dart';
// import 'tools/bmi_input.dart';
// import 'tools/bmi_result_screen.dart';
// import 'tools/bmr_result_screen.dart';
// import 'tools/bmr_input.dart';
// import 'tools/body_fat_input.dart';
// import 'tools/tdee_input.dart';
// import 'tools/body_fat_result_screen.dart';
// import 'tools/tdee_result_screen.dart'; 
// import 'tools/health_connect_intro.dart';
// import 'tools/health_connect_toggle.dart';/// ✅ Add this

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     initialRoute: '/tools',
//     routes: {
//       '/tools': (context) => const ToolsScreen(),
//       '/bmi': (context) => const BMIScreenInput(),
//       '/bmr': (context) => const BMRScreenInput(),
//       '/bodyfat': (context) => const BodyFatInputPage(),
//       '/tdee': (context) => const TDEEScreenInput(),
//       '/health-connect': (context) => const HealthConnectIntroScreen(),
//       '/health-connect-toggle': (context) => const HealthConnectToggleScreen(),

//     },
//     onGenerateRoute: (settings) {
//       if (settings.name == '/bmi-result') {
//         final bmi = settings.arguments as double;
//         return MaterialPageRoute(
//           builder: (context) => BMIResultScreen(bmi: bmi),
//         );
//       }
//       if (settings.name == '/bmr-result') {
//         final bmr = settings.arguments as int;
//         return MaterialPageRoute(
//           builder: (context) => BmrResultScreen(bmr: bmr),
//         );
//       }
//      if (settings.name == '/bodyfat-result') {
//   final bodyFat = settings.arguments as double;
//   return MaterialPageRoute(
//     builder: (context) => BodyFatResultScreen(bodyFatPercentage: bodyFat),
//   );
// }

//       if (settings.name == '/tdee-result') {
//         final tdee = settings.arguments as double;
//         return MaterialPageRoute(
//           builder: (context) => TdeeResultScreen(tdee: tdee),
//         );
//       }
//       return null;
//     },
//   ));
// }
import 'package:flutter/material.dart';
import 'package:test_app/call/schedule_call.dart';
import 'package:test_app/gamification/levels_screen.dart';
import 'package:test_app/pages/home_page.dart';
import 'package:test_app/shift/cycle.dart';
import 'package:test_app/shift/nutrition_tracker.dart';
import 'package:test_app/shift/water.dart';
// import 'package:test_app/gamification/gamification_screen.dart';
import 'plan/fitness_wellness.dart'; // Make sure this path is correct
// import 'gamification/gamification_screen.dart';
import 'plan/calorie_tracker.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/', // Use '/' for default route
    routes: {
      '/': (context) => LevelsScreen(),
    },
  ));
}

