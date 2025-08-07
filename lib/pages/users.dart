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
      //final response = await http.get(Uri.parse('http://localhost:5151/User'));
      //final response = await http.get(Uri.parse('http://10.0.2.2:5151/User'));
      final response = await http.get(Uri.parse('${ApiService.baseUrl}/User'));

      
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
    if (id == null) {
      setState(() {
        fetchedUser = {'error': 'Invalid ID entered'};
      });
      return;
    }

    try {
      print('Fetching user with ID: $id');
      final user = await ApiService.getUserById(id);
      print('Fetched user data: $user');
      setState(() {
        fetchedUser = user; // Update state with the fetched user
      });
    } catch (e) {
      print('Error fetching user by ID: $e');
      setState(() {
        if (e.toString().toLowerCase().contains('not found')) {
          fetchedUser = {'error': 'Report with given ID not found'};
        } else {
          fetchedUser = {'error': 'An error occurred: $e'};
        }
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
      //final response = await http.delete(Uri.parse('http://localhost:5151/User/$id'));
      //final response = await http.delete(Uri.parse('http://10.0.2.2:5151/User/$id'));
      final response = await http.delete(Uri.parse('${ApiService.baseUrl}/User/$id'));


      if (!mounted) return;
      
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
    //String baseUrl = "http://localhost:5151/";
    //String baseUrl = "http://10.0.2.2:5151/";
    final baseUrl = ApiService.baseUrl;

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
                      // Name input for new user
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
                      // ID input for fetching specific user
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
                      // Display fetched user
                      if (fetchedUser != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: fetchedUser!.containsKey('error')
                              ? Text(fetchedUser!['error'], style: TextStyle(color: Colors.red))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Fetched Report: ${fetchedUser!['name']}"),
                                    Text("Location: ${fetchedUser!['latitude']}, ${fetchedUser!['longitude']}"),
                                    const SizedBox(height: 10),
                                    // Fixing the image URL path and displaying the image
                                    if (fetchedUser!.containsKey('imagePath') && fetchedUser!['imagePath'] != null)
                                      Column(
                                        children: [
                                          // Fixing the backslash and prepending base URL
                                          //Text("Image URL: ${baseUrl + 'images/' + fetchedUser!['imagePath'].split(r"\").last}"),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.network(
                                              baseUrl + '/images/' + fetchedUser!['imagePath'].split(r"\").last, // Use the corrected image URL
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Icon(Icons.image_not_supported, size: 80, color: Colors.grey), // Fallback if no image
                                  ],
                                ),
                        ),
                      const Divider(),
                      // List of users
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            String imageUrl = '';
                            if (user['imagePath'] != null) {
                              // Ensure we handle backslashes and construct a proper URL
                              //imageUrl = baseUrl + 'images/' + user['imagePath'].split(r"\").last;
                              imageUrl = baseUrl + '/images/' + user['imagePath'].split(RegExp(r'[\\/]+')).last;

                            }

                            // Decide on how to display the image
                            final imageWidget = imageUrl.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      imageUrl, // Display image from URL
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(Icons.image_not_supported, size: 50, color: Colors.grey); // Fallback if no image

                            return ListTile(
                              leading: imageWidget,
                              title: Text('${user['id']}. ${user['name']}'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deleteUser(user['id']),
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