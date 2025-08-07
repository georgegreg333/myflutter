import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'coordinate_extractor.dart';
import 'api_service.dart';


class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _imageFile;
  final picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  String _message = '';
  String? _latitude;
  String? _longitude;

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileNameWithoutExt = basenameWithoutExtension(pickedFile.path);
      setState(() {
        _imageFile = File(pickedFile.path);
        _nameController.text = fileNameWithoutExt;
        _message = ''; // Clear previous message
      });
    }
  }

  Future<void> uploadUser() async {
    if (_imageFile == null || _nameController.text.isEmpty) {
      setState(() {
        _message = 'Please enter a name and select an image.';
      });
      return;
    }

    // Extract coordinates from the image (make sure to pass a File object)
    final coords = await CoordinateExtractor.extractRawCoordinates(_imageFile!);

    if (coords != null) {
      setState(() {
        _latitude = coords['latitude'];
        _longitude = coords['longitude'];
      });
      print("Coordinates found: ${coords['latitude']}, ${coords['longitude']}");
    } else {
      setState(() {
        _latitude = 'No coordinates found';
        _longitude = 'No coordinates found';
      });
      print("No coordinates found.");
    }

    final bytes = await _imageFile!.readAsBytes();
    String base64Image = base64Encode(bytes);

    //final url = Uri.parse('http://localhost:5151/User/upload');
    //final url = Uri.parse('http://10.0.2.2:5151/User/upload');
    final url = Uri.parse('${ApiService.baseUrl}/User/upload');

    final body = json.encode({
      'image': base64Image,
      'name': _nameController.text,
      'latitude': _latitude,  // Pass the latitude extracted from EXIF
      'longitude': _longitude,  // Pass the longitude extracted from EXIF
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      setState(() {
        if (response.statusCode == 200) {
          _message = '✅ User uploaded successfully!';
        } else {
          _message = '❌ Upload failed. Server responded with status ${response.statusCode}.';
        }
      });
    } catch (e) {
      setState(() {
        _message = '⚠️ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Image')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Enter name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image'),
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Selected: ${basename(_imageFile!.path)}'),
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: uploadUser,
              child: const Text('Upload User Info'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: TextStyle(
                color: _message.startsWith('✅') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_latitude != null && _longitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Coordinates:\nLatitude: $_latitude\nLongitude: $_longitude',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
