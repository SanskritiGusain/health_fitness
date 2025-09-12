import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/api/api_service.dart';
import 'package:test_app/chat/chat_start.dart';
import 'package:test_app/utils/circlular progressbar.dart';
import 'package:test_app/utils/custom_bottom_nav.dart';
import 'package:test_app/utils/custom_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:test_app/provider/day_provider.dart';
class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}


class _DietScreenState extends State<DietScreen> {
  Map<String, dynamic>? dietData;
  bool isLoading = true;
  String? errorMessage;
  // Target totals (from today's plan)
  double targetCalories = 0;
  double targetCarbs = 0;
  double targetProtein = 0;
  double targetFat = 0;

  // Consumed (derived) – always recomputed from _selected map
  double consumedCalories = 0;
  double consumedCarbs = 0;
  double consumedProtein = 0;
  double consumedFat = 0;

  // keep track of which meals are selected
  Set<String> selectedMeals = {};

  // Master index of meals by stable key
  final Map<String, Map<String, dynamic>> _mealsByKey = {};
  // Selection state lives ONLY here (single source of truth)
  final Map<String, bool> _selected = {};

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  final selectedDay = context.watch<SelectedDayProvider>().selectedDay;
  _fetchDietData(selectedDay);
}


Future<void> _fetchDietData(int day) async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final response = await ApiService.getRequest('user/daily-plan?day=$day');
    print("Raw Response => $response");

    final diet = response['plan']?['diet'];
    Map<String, dynamic>? data;

    if (diet != null) {
      if (diet is Map && diet['diet_plan'] != null && diet['diet_plan'] is Map) {
        data = Map<String, dynamic>.from(diet['diet_plan']);
      } else if (diet is Map) {
        data = Map<String, dynamic>.from(diet);
      }
    }

    if (data != null) {
      _mealsByKey.clear();
      _selected.clear();
      _indexMeals(data);
      _calculateTargets();

      setState(() {
        dietData = data;
        isLoading = false;
      });

      _recalculateTotals();
    } else {
      setState(() {
        dietData = null;
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}

  // Create a stable key for a meal (use id if present, else a composite)
  String _makeKey(Map<String, dynamic> meal, String slot, int idx) {
    final id = meal['id']?.toString();
    if (id != null && id.isNotEmpty) return '$slot#$id';
    final name = (meal['name'] ?? '').toString();
    final kcal = (meal['calories'] ?? '').toString();
    final m = meal['macros'] ?? {};
    final c = (m['carbs_grams'] ?? '').toString();
    final p = (m['protein_grams'] ?? '').toString();
    final f = (m['fats_grams'] ?? '').toString();
    return '$slot#$idx#$name#$kcal#$c#$p#$f';
  }

  void _indexMeals(Map<String, dynamic> data) {
    final meals = data['meals'] ?? {};

    void addOne(String slot, dynamic meal, int idx) {
      if (meal == null) return;
      final key = _makeKey(meal as Map<String, dynamic>, slot, idx);
      _mealsByKey[key] = meal;
      _selected[key] = false; // default unchecked
    }

    addOne('breakfast', meals['breakfast'], 0);
    addOne('lunch', meals['lunch'], 0);
    addOne('dinner', meals['dinner'], 0);

    if (meals['snacks'] is List) {
      final snacks = meals['snacks'] as List;
      for (var i = 0; i < snacks.length; i++) {
        addOne('snacks', snacks[i], i);
      }
    }
  }

  void _calculateTargets() {
    double cals = 0, carbs = 0, prot = 0, fat = 0;

    _mealsByKey.forEach((key, meal) {
      if (meal == null) return;

 final macros = meal['macros'] != null 
    ? Map<String, dynamic>.from(meal['macros'])
    : <String, dynamic>{};

cals += ((meal['calories'] ?? 0) as num).toDouble();
carbs += ((macros['carbs_grams'] ?? 0) as num).toDouble();
prot  += ((macros['protein_grams'] ?? 0) as num).toDouble();
fat   += ((macros['fats_grams'] ?? 0) as num).toDouble();
 });

    setState(() {
      targetCalories = cals;
      targetCarbs = carbs;
      targetProtein = prot;
      targetFat = fat;
    });
  }

  void _toggleMeal(String key, bool checked) {
    setState(() {
      _selected[key] = checked;
    });
    _recalculateTotals();
  }

  void _recalculateTotals() {
    double cals = 0, carbs = 0, prot = 0, fat = 0;

    _selected.forEach((key, isOn) {
      if (!isOn) return;
      final meal = _mealsByKey[key];
      if (meal == null) return;

     final macros = meal['macros'] != null 
    ? Map<String, dynamic>.from(meal['macros'])
    : <String, dynamic>{};


      cals += ((meal['calories'] ?? 0) as num).toDouble();
      carbs += ((macros['carbs_grams'] ?? 0) as num).toDouble();
      prot += ((macros['protein_grams'] ?? 0) as num).toDouble();
      fat += ((macros['fats_grams'] ?? 0) as num).toDouble();
    });

    setState(() {
      consumedCalories = cals;
      consumedCarbs = carbs;
      consumedProtein = prot;
      consumedFat = fat;
    });
  }

  @override
  Widget build(BuildContext context) {
                  final selectedDay = context.read<SelectedDayProvider>().selectedDay;
    final body =
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
  Text(
    'Error: $errorMessage',
    style: const TextStyle(color: Colors.red),
    textAlign: TextAlign.center,
  ),
  const SizedBox(height: 16),
//final selectedDay = context.read<SelectedDayProvider>().selectedDay; // ❌ invalid here
  ElevatedButton(
    onPressed: () => _fetchDietData(selectedDay),
    child: const Text('Retry'),
  ),
],

              ),
            )
            : dietData == null
            ? const Center(child: Text('No diet data available'))
            : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMacronutrientSection(),
                  const SizedBox(height: 16),

                  // Ask Luna banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE3F8B6), Color(0xFFB2F8F4)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "💬 Ask Luna to modify or change your plan",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                   Text(
                    "Today Plan",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                      color: Colors.black),
                  ),
                  const SizedBox(height: 12),

                  // Breakfast
                  ..._sectionFor('Breakfast', 'breakfast'),
                  // Lunch
                  ..._sectionFor('Lunch', 'lunch'),
                  // Dinner
                  ..._sectionFor('Dinner', 'dinner'),

                  // Snacks (multiple)
                  ..._snacksSection(),
                ],
              ),
            );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Diet"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: body,
        bottomNavigationBar: const CustomNavBar(currentIndex: 1),
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 170, 207, 171),
          label: const Text(
            "Ask Luna",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          icon: Image.asset("assets/icons/ai.png", height: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          extendedPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
List<Widget> _sectionFor(String title, String slot) {
  final meal = dietData?['meals']?[slot];
  if (meal == null) return [];

  final key = _makeKey(meal, slot, 0);
  return [
    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
    const SizedBox(height: 8),
    MealCard(
      key: ValueKey(key),
      mealData: meal,
      isChecked: _selected[key] ?? false,
      onChecked: (checked) => _toggleMeal(key, checked),
    ),
    const SizedBox(height: 16),
  ];
}

List<Widget> _snacksSection() {
  final snacks = dietData?['meals']?['snacks'];
  if (snacks == null || snacks is! List || snacks.isEmpty) return [];

  return [
    const SizedBox(height: 8),
    const Text("Snacks", style: TextStyle(fontWeight: FontWeight.w600)),
    const SizedBox(height: 8),
    ...List<Widget>.generate(snacks.length, (i) {
      final snack = snacks[i];
      final key = _makeKey(snack, 'snacks', i);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: MealCard(
          key: ValueKey(key),
          mealData: snack,
          isChecked: _selected[key] ?? false,
          onChecked: (checked) => _toggleMeal(key, checked),
        ),
      );
    }),
  ];
}


  
  Widget _buildMacronutrientSection() {
    // final macros = (dietData!['macros'] ?? {}) as Map<String, dynamic>;
    final dailyCalories = targetCalories;

    final progress =
        dailyCalories == 0
            ? 0.0
            : (consumedCalories / dailyCalories).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Macronutrient Breakdown",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Circular progress for calories
          Stack(
            alignment: Alignment.center,
            children: [
              RoundedCircularProgress(
                progress: progress,
                remainingText:
                    "${(dailyCalories - consumedCalories).clamp(0, double.infinity).toInt()} Kcal\nRemaining",
              ),
              Text(
                "${(dailyCalories - consumedCalories).clamp(0, double.infinity).toInt()} Kcal\nRemaining",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Macro bars
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MacroStat(
                label: "Carbs",
                consumed: consumedCarbs,
                total: targetCarbs,
              ),
              _MacroStat(
                label: "Protein",
                consumed: consumedProtein,
                total: targetProtein,
              ),
              _MacroStat(label: "Fat", consumed: consumedFat, total: targetFat),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- UI widgets -----------------

class _MacroStat extends StatelessWidget {
  final String label;
  final double consumed;
  final double total;

  const _MacroStat({
    super.key,
    required this.label,
    required this.consumed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotal = total <= 0 ? 1.0 : total; // avoid divide-by-zero
    final progress = (consumed / safeTotal).clamp(0.0, 1.0);
    final value = "${consumed.toInt()}/${total.toInt()}g";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),

        SizedBox(
          width: 50,
          height: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: _getColor(label),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Color _getColor(String label) {
    switch (label.toLowerCase()) {
      case "carbs":
        return const Color(0xFFA26A55);
      case "protein":
        return const Color(0xFFB5282B);
      case "fat":
        return const Color(0xFFE7B900);
      default:
        return Colors.green;
    }
  }
}

class MealCard extends StatelessWidget {
  final Map<String, dynamic> mealData;
  final bool isChecked;
  final ValueChanged<bool> onChecked;

  const MealCard({
    super.key,
    required this.mealData,
    required this.isChecked,
    required this.onChecked,
  });

  void _showMealDetailsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealDetailsBottomSheet(mealData: mealData),
    );
  }

  @override
  Widget build(BuildContext context) {
final macros = mealData['macros'] != null
    ? Map<String, dynamic>.from(mealData['macros'])
    : <String, dynamic>{};

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Row 1 (Name + calendar + checkbox) ----------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (mealData['name'] ?? '').toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showMealDetailsBottomSheet(context),
                    child: const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  CustomSvgCheckbox(
                    value: isChecked,
                    onChanged: (newValue) => onChecked(newValue ?? false),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ---------- Row 2 (Image + details) ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: Image
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons_update/besan.svg", // TODO: make dynamic
                    width: 36,
                    height: 36,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Right column: Details (aligned right)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (mealData['regional_name'] ?? '').toString(),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/icons_update/mdi_fire.svg",
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${((mealData['calories'] ?? 0) as num).toInt()} Kcal",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Macros row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons_update/carbs.svg",
                              height: 14,
                           
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "C: ${((macros['carbs_grams'] ?? 0) as num).toInt()}g",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons_update/protein.svg",
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "P: ${((macros['protein_grams'] ?? 0) as num).toInt()}g",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons_update/fat.svg",
                              height: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "F: ${((macros['fats_grams'] ?? 0) as num).toInt()}g",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class MealDetailsBottomSheet extends StatelessWidget {
  final Map<String, dynamic> mealData;

  const MealDetailsBottomSheet({super.key, required this.mealData});

  @override
  Widget build(BuildContext context) {
    final ingredients = mealData['ingredients'] as List<dynamic>? ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (mealData['regional_name'] ?? mealData['name'] ?? '')
                    .toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // Ingredients label
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons_update/incredient.svg",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Ingredients list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children:
                    ingredients
                        .map<Widget>(
                          (ingredient) => _IngredientRow(
                            ingredient: ingredient.toString(),
                            quantity: "",
                          ),
                        )
                        .toList(),
              ),
            ),
          ),

          // Prep instructions
          if (mealData['prep_instructions'] != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Preparation:",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mealData['prep_instructions'].toString(),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _IngredientRow extends StatelessWidget {
  final String ingredient;
  final String quantity;

  const _IngredientRow({
    super.key,
    required this.ingredient,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 3,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ingredient,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
          if (quantity.isNotEmpty)
            Text(
              quantity,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}
