import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserUpdateFormPage extends StatefulWidget {
  const UserUpdateFormPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserUpdateFormPageState createState() => _UserUpdateFormPageState();
}

class _UserUpdateFormPageState extends State<UserUpdateFormPage> {
  late User user;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstnameController;
  late TextEditingController lastnameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController ageController;
  late TextEditingController tmoneyController;
  late TextEditingController tprofitController;

  bool _isLoading = false;
  bool _controllersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is User) {
      user = args;

      if (!_controllersInitialized) {
        firstnameController = TextEditingController(text: user.firstname);
        lastnameController = TextEditingController(text: user.lastname);
        emailController = TextEditingController(text: user.email);
        addressController = TextEditingController(text: user.address);
        ageController = TextEditingController(text: user.age?.toString() ?? '');
        tmoneyController = TextEditingController(text: user.totalMoneySaved?.toString() ?? '');
        tprofitController = TextEditingController(text: user.totalProfit?.toString() ?? '');
        
        _controllersInitialized = true;
      }
    } else {
      // No user passed, close page
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    addressController.dispose();
    ageController.dispose();
    tmoneyController.dispose();
    tprofitController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedUser = User(
      id: user.id, // keep original ID
      firstname: firstnameController.text,
      lastname: lastnameController.text,
      email: emailController.text,
      address: addressController.text,
      age: ageController.text.isNotEmpty
          ? int.parse(ageController.text)
          : null,
      totalMoneySaved: tmoneyController.text.isNotEmpty
          ? double.parse(tmoneyController.text)
          : null,
      totalProfit: tprofitController.text.isNotEmpty
          ? double.parse(tprofitController.text)
          : null,
    );

    try {
      await UserService().updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User updated')),
      );
      Navigator.of(context).pop(true); // Notify previous screen to refresh
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ?? (val) => val == null || val.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_controllersInitialized) {
      // Show loading while user data isn't ready
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Firstname', firstnameController),
              _buildTextField('Lastname', lastnameController),
              _buildTextField('Email', emailController,
                  keyboardType: TextInputType.emailAddress, validator: (val) {
                if (val == null || val.isEmpty) return 'Enter Email';
                if (!val.contains('@')) return 'Enter a valid email';
                return null;
              }),
              _buildTextField('Address', addressController),
              _buildTextField('Age', ageController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter Age';
                    if (int.tryParse(val) == null) return 'Enter a valid number';
                    return null;
                  }),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Update User'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
