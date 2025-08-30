import 'package:flutter/material.dart';

import 'package:test_app/theme/app_theme.dart';
class CycleInsightScreen extends StatefulWidget {
  @override
  _CycleInsightScreenState createState() => _CycleInsightScreenState();
}

class _CycleInsightScreenState extends State<CycleInsightScreen> {
  bool isEditing = false;

  // Controllers for editable fields
  TextEditingController avgPeriodDurationController = TextEditingController(
    text: '5 Days',
  );
  TextEditingController avgCycleLengthController = TextEditingController(
    text: '28 Days',
  );
  TextEditingController isCycleRegularController = TextEditingController(
    text: 'Yes',
  );
  TextEditingController medicalConditionController = TextEditingController(
    text: 'PCOS',
  );
  TextEditingController medicinesController = TextEditingController(
    text: 'Neurofenix',
  );

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cycle Insight',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        
actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  _saveChanges();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Changes saved successfully")),
                  );
                }
                isEditing = !isEditing;
              });
            },
          ),
          const SizedBox(width: 16),
        ],

      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row - Average period duration and Average cycle length
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Average period duration',
                    controller: avgPeriodDurationController,
                    hintText: 'Enter duration',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Average cycle length',
                    controller: avgCycleLengthController,
                    hintText: 'Enter cycle length',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Second Row - Is your cycle regular and medical condition
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Is your cycle regular',
                    controller: isCycleRegularController,
                    hintText: 'Yes/No',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    title: 'medical condition',
                    controller: medicalConditionController,
                    hintText: 'Enter condition',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Third Row - Do you take any medicines
             _buildInfoCard(
              title: 'Do you take any medicines',
              controller: medicinesController,
              hintText: 'Enter medicines',
            ),
          ],
        ),
      ),
        bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: handle save
              print("Bottom button pressed");
            },
            child: Text(
              "Save Changes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 46,
        child: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Add Ask Luna API here
          },
          backgroundColor: theme.colorScheme.primary,
          label: Text(
            "Ask Luna",
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.surface,
              fontWeight: FontWeight.w700,
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

  Widget _buildInfoCard({
    required String title,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      padding: EdgeInsets.all(6),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          if (isEditing)
            TextFormField(
              controller: controller,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.normal,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                fillColor: Colors.grey.shade50,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                isDense: true,
              ),
            )
          else
            Text(
              controller.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
void _saveChanges() {
    print('Saved changes:');
    print('Avg Period Duration: ${avgPeriodDurationController.text}');
    print('Avg Cycle Length: ${avgCycleLengthController.text}');
    print('Is Cycle Regular: ${isCycleRegularController.text}');
    print('Medical Condition: ${medicalConditionController.text}');
    print('Medicines: ${medicinesController.text}');
  }
  @override
  void dispose() {
    avgPeriodDurationController.dispose();
    avgCycleLengthController.dispose();
    isCycleRegularController.dispose();
    medicalConditionController.dispose();
    medicinesController.dispose();
    super.dispose();
  }
}
