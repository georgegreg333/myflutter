import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart'; // Importing ApiService to handle API requests

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  int _counter = 0;
  List users = []; // List to store users fetched from the API
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // To store error messages, if any
  Map<String, dynamic>? fetchedUser; // Store a user fetched by ID
  TextEditingController idController = TextEditingController(); // Controller for the user ID input field
  TextEditingController nameController = TextEditingController(); // Controller for the user name input field

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Call fetchUsers method on page initialization
  }

  // Fetch all users from the API
  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      // Make GET request to fetch users
      final response = await http.get(Uri.parse('https://localhost:7202/api/TrackWaste'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body); // Parse the response into a list
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load reports.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }
  
  // Fetch a user by ID
  Future<void> fetchUserById() async {
    final id = int.tryParse(idController.text); // Try parsing the ID from the input field
    if (id == null) return;

    try {
      // Fetch user details by calling ApiService
      final user = await ApiService.getUserById(id);
      setState(() {
        fetchedUser = user; // Update state with the fetched user
      });
    } catch (e) {
      setState(() {
        fetchedUser = {'error': 'Report not found or error occurred'};
      });
    }
  }

  // Insert a new user
  Future<void> insertUser() async {
    final name = nameController.text.trim(); // Get the name from the input field
    if (name.isNotEmpty) {
      try {
        await ApiService.insertUser(name); // Call API service to insert user
        nameController.clear(); // Clear the name input field after insertion
        fetchUsers(); // Refresh the list after insertion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report "$name" added.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add report: $e')),
        );
      }
    }
  }

  // Delete user by ID
  Future<void> deleteUser(int id) async {
  try {
    // Send DELETE request to the API to delete the user by ID
    final response = await http.delete(Uri.parse('https://localhost:7202/api/TrackWaste/$id'));
    print (response);

    if (response.statusCode == 204) {  // No Content - successful deletion
      // Remove the deleted user from the local list of users.
      setState(() {
        users.removeWhere((user) => user['id'] == id); // Remove user from list
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User deleted successfully')),
      );
    } else {
      // If deletion fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete report')),
      );
    }
  } catch (e) {
    // Handle error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Waste Disposal Reports')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Enter report name to insert',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: insertUser,
                        child: Text('Add Report'),
                      ),
                      const Divider(),
                      TextField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Report ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: fetchUserById,
                        child: Text('Fetch Report by ID'),
                      ),
                      if (fetchedUser != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: fetchedUser!.containsKey('error')
                              ? Text(fetchedUser!['error'],
                                  style: TextStyle(color: Colors.red))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Fetched Report: ${fetchedUser!['name']}'),
                                    SizedBox(height: 4),
                                    Text('Description: ${fetchedUser!['description']}'),
                                    SizedBox(height: 4),
                                    Text('Address: ${fetchedUser!['address']}'),
                                    SizedBox(height: 4),
                                    Text('Date: ${fetchedUser!['date']}'),
                                    SizedBox(height: 4),
                                    Text('Image: ${fetchedUser!['image']}'),
                                  ],
                                ),
                        ),
                      const Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              // Show ID and Name
                              title: Text('${users[index]['id']}. ${users[index]['name']}'),
                              // Show more fields in the subtitle
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Description: ${users[index]['description']}'),
                                  Text('Address: ${users[index]['address']}'),
                                  Text('Date: ${users[index]['date']}'),
                                  Text('Image: ${users[index]['image']}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  deleteUser(users[index]['id']); // Call delete method
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
