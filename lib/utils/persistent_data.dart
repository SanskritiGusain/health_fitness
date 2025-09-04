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

  /// Save location data
  static Future<void> saveLocation({
    required String country,
    required String countryId,
    String? state,
    String? stateId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyCountry, country);
    await prefs.setString(keyCountryId, countryId);
    if (state != null) await prefs.setString(keyState, state);
    if (stateId != null) await prefs.setString(keyStateId, stateId);
  }

  /// Save height (always in cm)
  static Future<void> saveHeight(double heightCm) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyHeight, heightCm);
  }

  /// Save weight (always in kg)
  static Future<void> saveWeight(double weightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyWeight, weightKg);
  }

  /// Save target weight (always in kg)
  static Future<void> saveTargetWeight(double targetWeightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyTargetWeight, targetWeightKg);
  }

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
  }

  /// Save diet preferences
  static Future<void> saveDietPreferences({
    required String level,
    required List<String> goalOptions,
    required List<String> allergies,
    required List<String> specialNeeds,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyDietLevel, level);
    await prefs.setStringList(keyDietGoalOptions, goalOptions);
    await prefs.setStringList(keyDietAllergies, allergies);
    await prefs.setStringList(keyDietSpecialNeeds, specialNeeds);
  }

  /// Save auth details
  static Future<void> saveAuthDetails({
    required String authId,
    required String authProvider,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyAuthId, authId);
    await prefs.setString(keyAuthProvider, authProvider);
    if (email != null) await prefs.setString(keyEmail, email);
  }

  /// Get all persistent data formatted for API
  static Future<Map<String, dynamic>> getAllPersistentData() async {
    final prefs = await SharedPreferences.getInstance();

    // Calculate BMI
    final height = prefs.getDouble(keyHeight) ?? 0;
    final weight = prefs.getDouble(keyWeight) ?? 0;
    final heightInMeters = height / 100;
    final bmi = weight > 0 && heightInMeters > 0 
        ? weight / (heightInMeters * heightInMeters) 
        : 0;

    return {
      "name": prefs.getString(keyName) ?? "",
      "email": prefs.getString(keyEmail) ?? "user@example.com",
      "age": prefs.getInt(keyAge) ?? 0,
      "gender": prefs.getString(keyGender) ?? "",
      "country_id": prefs.getString(keyCountryId) ?? "",
      "state_id": prefs.getString(keyStateId),
      "current_height": height.toInt(),
      "current_weight": weight.toInt(),
      "current_bmi": bmi.toInt(),
      "target_weight": (prefs.getDouble(keyTargetWeight) ?? weight).toInt(),
      "level_id": _getLevelId(prefs.getString(keyWorkoutLevel) ?? ""),
      "workout_type_ids": _getWorkoutTypeIds(prefs.getStringList(keyWorkoutTypes) ?? []),
      "time_availability": prefs.getString(keyTimeAvailability) ?? "",
      "special_needs": (prefs.getStringList(keySpecialNeeds) ?? []).join(", "),
      "conditions": prefs.getStringList(keySpecialNeeds) ?? [],
      "dietary_preferences": prefs.getStringList(keyDietGoalOptions) ?? [],
      "goal_options": prefs.getStringList(keyDietGoalOptions) ?? [],
      "allergies": prefs.getStringList(keyDietAllergies) ?? [],
      "dietary_special_needs": prefs.getStringList(keyDietSpecialNeeds) ?? [],
      "auth_id": prefs.getString(keyAuthId) ?? "",
      "auth_provider": prefs.getString(keyAuthProvider) ?? "",
    };
  }

  /// Clear all saved data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Helper method to map level names to IDs (you'll need to adjust these based on your backend)
  static String _getLevelId(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return '550e8400-e29b-41d4-a716-446655440001';
      case 'intermediate':
        return '550e8400-e29b-41d4-a716-446655440002';
      case 'advanced':
        return '550e8400-e29b-41d4-a716-446655440003';
      default:
        return '';
    }
  }

  /// Helper method to map workout types to IDs (you'll need to adjust these based on your backend)
  static List<String> _getWorkoutTypeIds(List<String> workoutTypes) {
    final Map<String, String> typeToIdMap = {
      'Home Workouts': '550e8400-e29b-41d4-a716-446655440011',
      'Gym Workouts': '550e8400-e29b-41d4-a716-446655440012',
      'Yoga & Stretching': '550e8400-e29b-41d4-a716-446655440013',
      'Pilates': '550e8400-e29b-41d4-a716-446655440014',
      'Cardio': '550e8400-e29b-41d4-a716-446655440015',
      'Strength Training': '550e8400-e29b-41d4-a716-446655440016',
      'Dance Workouts': '550e8400-e29b-41d4-a716-446655440017',
    };

    return workoutTypes
        .map((type) => typeToIdMap[type])
        .where((id) => id != null)
        .cast<String>()
        .toList();
  }
// lib/utils/persistent_data.dart

  /// Data for first API call (Screens 1–4)
  static Future<Map<String, dynamic>> getFirstPhaseUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "name": prefs.getString(keyName) ?? "",
      "age": prefs.getInt(keyAge) ?? 0,
      "gender": prefs.getString(keyGender) ?? "",
      "country_id": prefs.getString(keyCountryId) ?? "",
      "state_id": prefs.getString(keyStateId),
      "current_height": (prefs.getDouble(keyHeight) ?? 0).toInt(),
      "current_weight": (prefs.getDouble(keyWeight) ?? 0).toInt(),
    };
  }

  /// Get specific data pieces for debugging or display
  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyName);
  }

  static Future<int?> getAge() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyAge);
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyGender);
  }

  static Future<double?> getHeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyHeight);
  }

  static Future<double?> getWeight() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(keyWeight);
  }

  static Future<String?> getCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyCountry);
  }

  static Future<String?> getState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyState);
  }
}