// lib/utils/persistent_data.dart
import 'package:shared_preferences/shared_preferences.dart';

class PersistentData {
  // Keys for SharedPreferences
  static const String keyName = 'user_name';
  static const String keyAge = 'user_age';
  static const String keyGender = 'user_gender';
  static const String keyCountry = 'user_country';
  static const String keyCountryId = 'user_country_id';
  static const String keyState = 'user_state';
  static const String keyStateId = 'user_state_id';
  static const String keyHeight = 'user_height';
  static const String keyWeight = 'user_weight';
  static const String keyTargetWeight = 'user_target_weight';
  static const String keyWorkoutLevel = 'workout_level';
  static const String keyWorkoutTypes = 'workout_types';
  static const String keyTimeAvailability = 'time_availability';
  static const String keySpecialNeeds = 'special_needs';
  static const String keyDietLevel = 'diet_level';
  static const String keyDietGoalOptions = 'diet_goal_options';
  static const String keyDietAllergies = 'diet_allergies';
  static const String keyDietSpecialNeeds = 'diet_special_needs';
  static const String keyAuthId = 'auth_id';
  static const String keyAuthProvider = 'auth_provider';
  static const String keyEmail = 'user_email';

  /// Save user basic details
  static Future<void> saveUserDetails({
    required String name,
    required int age,
    required String gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, name);
    await prefs.setInt(keyAge, age);
    await prefs.setString(keyGender, gender);
  }

  static const String keyAuthToken = 'auth_token';

  /// Save backend auth token
  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAuthToken, token);
  }

  /// Get backend auth token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAuthToken);
  }

  /// Save location data
  static Future<void> saveLocation({
    required String country,
    required String countryId,
    String? state,
    String? stateId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyCountry, country);
    await prefs.setString(keyCountryId, countryId); // always required

    if (state != null) await prefs.setString(keyState, state);
    if (stateId != null && stateId.isNotEmpty)
      await prefs.setString(keyStateId, stateId);
  }

  /// Backward compatibility (old method names)
  static Future<String?> getCountryId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCountryId);
  }

  static Future<String?> getCountryName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCountry);
  }

  static Future<String?> getStateId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyStateId);
  }

  static Future<String?> getStateName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyState);
  }

  /// Newer getters
  static Future<String?> getCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCountry);
  }

  static Future<String?> getState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyState);
  }

  /// Save height (cm)
  static Future<void> saveHeight(double heightCm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyHeight, heightCm);
  }

  /// Save weight (kg)
  static Future<void> saveWeight(double weightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyWeight, weightKg);
  }

  /// Save target weight (kg)
  static Future<void> saveTargetWeight(double targetWeightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyTargetWeight, targetWeightKg);
  }

  /// Get all persistent data formatted for API

  /// Save workout preferences
  static Future<void> saveWorkoutPreferences({
    required String level,
    required List<String> workoutTypes,
    required String timeAvailability,
    required List<String> specialNeeds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(keyWorkoutLevel, level);
    await prefs.setStringList(keyWorkoutTypes, workoutTypes);
    await prefs.setString(keyTimeAvailability, timeAvailability);
    await prefs.setStringList(keySpecialNeeds, specialNeeds);

    print("✅ Workout preferences saved:");
    print({
      "level": level,
      "workout_types": workoutTypes,
      "time_availability": timeAvailability,
      "special_needs": specialNeeds,
    });
  }

  /// Save diet preferences
  static Future<void> saveDietPreferences({
    required String dietLevel,
    required List<String> goalOptions,
    required List<String> allergies,
    required List<String> specialNeeds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(keyDietLevel, dietLevel);
    await prefs.setStringList(keyDietGoalOptions, goalOptions);
    await prefs.setStringList(keyDietAllergies, allergies);
    await prefs.setStringList(keyDietSpecialNeeds, specialNeeds);

    print("✅ Diet preferences saved:");
    print({
      "diet_level": dietLevel,
      "goal_options": goalOptions,
      "allergies": allergies,
      "special_needs": specialNeeds,
    });
  }

  // /// Get all persistent data formatted for API
  // static Future<Map<String, dynamic>> getAllPersistentData() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   // Calculate BMI
  //   final height = prefs.getDouble(keyHeight) ?? 0;
  //   final weight = prefs.getDouble(keyWeight) ?? 0;
  //   // final heightInMeters = height / 100;

  //   String? uuidOrNull(String? value) =>
  //       (value != null && value.isNotEmpty) ? value : null;

  //   return {
  //     // 🔹 Basic details
  //     "name": prefs.getString(keyName) ?? "",

  //     "age": prefs.getInt(keyAge) ?? 0,
  //     "gender": prefs.getString(keyGender) ?? "",

  //     // 🔹 Location
  //     "country_id": prefs.getString(keyCountryId) ?? "",
  //     "state_id": uuidOrNull(prefs.getString(keyStateId)),

  //     // 🔹 Physical
  //     "current_height": height.toInt(),
  //     "current_weight": weight.toInt(),
  //     // "current_bmi": bmi.toInt(),
  //     "target_weight": (prefs.getDouble(keyTargetWeight) ?? weight).toInt(),

  //     // 🔹 Workout preferences
  //     // "level_id": prefs.getString(keyWorkoutLevel),
  //     // "workout_type_ids": prefs.getStringList(keyWorkoutTypes),
  //     // "time_availability": prefs.getString(keyTimeAvailability),
  //     // "special_needs": prefs.getStringList(keySpecialNeeds),

  //     // 🔹 Diet preferences
  //    "dietary_preferences":
  //         (prefs.getStringList(keyDietLevel) ?? [])
  //             .map((e) => e.toLowerCase())
  //             .toList(),
  //     "goal_options": prefs.getStringList(keyDietGoalOptions) ?? [],
  //     "allergies": prefs.getStringList(keyDietAllergies) ?? [],
  //     "dietary_special_needs": prefs.getStringList(keyDietSpecialNeeds) ?? [],
  //   };
  // }
  static Future<Map<String, dynamic>> getAllPersistentData() async {
    final prefs = await SharedPreferences.getInstance();

    String? uuidOrNull(String? value) =>
        (value != null && value.isNotEmpty) ? value : null;

    final dietaryPreferences = prefs.getStringList(keyDietLevel) ?? [];
    final goalOptions = prefs.getStringList(keyDietGoalOptions) ?? [];
    final allergies = prefs.getStringList(keyDietAllergies) ?? [];
    final dietarySpecialNeeds = prefs.getStringList(keyDietSpecialNeeds) ?? [];

    return {
      // 🔹 Basic details
      "name": prefs.getString(keyName) ?? "",
      "age": prefs.getInt(keyAge) ?? 0,
      "gender": prefs.getString(keyGender) ?? "",

      // 🔹 Location
      "country_id": prefs.getString(keyCountryId) ?? "",
      "state_id": uuidOrNull(prefs.getString(keyStateId)),

      // 🔹 Physical
      "current_height": (prefs.getDouble(keyHeight) ?? 0).toInt(),
      "current_weight": (prefs.getDouble(keyWeight) ?? 0).toInt(),
      "target_weight":
          (prefs.getDouble(keyTargetWeight) ??
                  (prefs.getDouble(keyWeight) ?? 0))
              .toInt(),

      // "level": prefs.getString(keyWorkoutLevel),
      // "workout_type": prefs.getStringList(keyWorkoutTypes),
      // "time_availability": prefs.getString(keyTimeAvailability),
      // "special_needs": prefs.getStringList(keySpecialNeeds),
      "level": keyWorkoutLevel,
      "workout_type": keyWorkoutTypes,
      "time_availability": keyTimeAvailability,
      "special_needs": keySpecialNeeds,
      // Send lists directly as JSON arrays
      "dietary_preferences": dietaryPreferences,
      "goal_options": goalOptions,
      "allergies": allergies,
      "dietary_special_needs": dietarySpecialNeeds,
    };
  }

  /// Data for first API call (Screens 1–4)
  static Future<Map<String, dynamic>> getFirstPhaseUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final height = prefs.getDouble(keyHeight) ?? 0;
    final weight = prefs.getDouble(keyWeight) ?? 0;

    // Helper to return null only for state_id
    String? uuidOrNull(String? value) =>
        (value != null && value.isNotEmpty) ? value : null;

    return {
      "name": prefs.getString(keyName) ?? "",
      "age": prefs.getInt(keyAge) ?? 0,
      "gender": prefs.getString(keyGender) ?? "",
      "country_id":
          prefs.getString(keyCountryId) ?? "", // mandatory, cannot be null
      "state_id": uuidOrNull(prefs.getString(keyStateId)), // can be null
      "current_height": height.toInt(),
      "current_weight": weight.toInt(),
    };
  }

  /// Clear all saved data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
