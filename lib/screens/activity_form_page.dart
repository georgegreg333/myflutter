import 'package:flutter/material.dart';
import '../models/activity.dart';
import '../services/activity_service.dart';

class ActivityFormPage extends StatefulWidget {
  final int userId; // User ID to associate activity with

  const ActivityFormPage({super.key, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityFormPageState createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final nameController = TextEditingController();
  final distanceController = TextEditingController();
  final caloriesController = TextEditingController();
  final typeController = TextEditingController();
  final timeController = TextEditingController();
  final co2Controller = TextEditingController();
  final moneysavedController = TextEditingController();
  final treesController = TextEditingController();
  final pointsController = TextEditingController();
  final profitController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    distanceController.dispose();
    caloriesController.dispose();
    typeController.dispose();
    timeController.dispose();
    co2Controller.dispose();
    moneysavedController.dispose();
    treesController.dispose();
    pointsController.dispose();
    profitController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final activity = Activity(
        id: null, // New activity
        name: nameController.text,
        userId: widget.userId,
        distance: double.parse(distanceController.text),
        type: typeController.text,
        calories: int.parse(caloriesController.text),
        time: int.parse(timeController.text),
        co2: int.parse(co2Controller.text),
        moneySaved: double.parse(moneysavedController.text),
        trees: int.parse(treesController.text),
        points: int.parse(pointsController.text),
        profit: double.parse(profitController.text),
      );

      print(activity.toJson());
      final createdActivity = await ActivityService().createActivity(activity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Activity created! ${createdActivity}')),
      );

      Navigator.of(context).pop(true); // Return to previous page, possibly refresh list

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating activity: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                label: 'Name',
                controller: nameController,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter name';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Distance (km)',
                controller: distanceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter distance';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Time (minutes)',
                controller: timeController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter time';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Type',
                controller: typeController,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter type of activity';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Calories',
                controller: caloriesController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter calories';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'CO2 (grams)',
                controller: co2Controller,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter CO2';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'MoneySaved',
                controller: moneysavedController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter Money Saved';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Trees',
                controller: treesController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter number of trees';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Points',
                controller: pointsController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter points';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Profit',
                controller: profitController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter profit';
                  if (double.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Add Activity'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}