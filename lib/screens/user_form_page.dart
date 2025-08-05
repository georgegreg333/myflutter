import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for user fields
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final tmoneyController = TextEditingController();
  final tprofitController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    tmoneyController.dispose();
    tprofitController.dispose();
    ageController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = User(
        id: null,
        firstname: firstnameController.text,
        lastname: lastnameController.text,
        totalMoneySaved: tmoneyController.text.isNotEmpty
            ? double.parse(tmoneyController.text)
            : null,
        totalProfit: tprofitController.text.isNotEmpty
            ? double.parse(tprofitController.text)
            : null,
        age: ageController.text.isNotEmpty ? int.parse(ageController.text) : null,
        address: addressController.text,
        email: emailController.text,
      );

      final createdUser = await UserService().createUser(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created (ID ${createdUser.id})')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(label: 'Firstname', controller: firstnameController),
              _buildTextField(label: 'Lastname', controller: lastnameController),
              _buildTextField(label: 'Address', controller: addressController),
              _buildTextField(
                label: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter Email';
                  if (!val.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              _buildTextField(
                label: 'Age',
                controller: ageController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter Age';
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Create User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}