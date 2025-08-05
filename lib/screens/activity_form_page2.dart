import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gpx/gpx.dart';

class ActivityFormPage extends StatefulWidget {
  final int userId; // User ID to associate activity with
  
  const ActivityFormPage({super.key, required this.userId});
  
  @override
  // ignore: library_private_types_in_public_api
  _ActivityFormPageState createState() => _ActivityFormPageState();
}

class _ActivityFormPageState extends State<ActivityFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();

  // GPX Import logic
  Future<void> _importGpxAndFillForm() async {
    final data = await _extractGpxInfo();
    if (data.isNotEmpty) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _distanceController.text = (data['distance'] ?? 0).toStringAsFixed(2);
        final duration = data['duration'] as Duration? ?? Duration.zero;
        _durationController.text = _formatDuration(duration);
        _typeController.text = data['type'] ?? '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load GPX or file empty')),
      );
    }
  }

  Future<Map<String, dynamic>> _extractGpxInfo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gpx'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final xmlString = await file.readAsString();
      final gpx = GpxReader().fromString(xmlString);

      final trk = gpx.trks.isNotEmpty ? gpx.trks.first : null;
      final segment = (trk?.trksegs.isNotEmpty ?? false) ? trk!.trksegs.first : null;
      if (trk == null || segment == null) return {};

      final points = segment.trkpts;
      if (points.length < 2) return {};

      double totalDistance = 0;
      DateTime? start = points.first.time;
      DateTime? end = points.last.time;

      for (var i = 1; i < points.length; i++) {
        final p1 = points[i - 1];
        final p2 = points[i];
        totalDistance += _calculateDistance(p1.lat!, p1.lon!, p2.lat!, p2.lon!);
      }

      Duration duration = (start != null && end != null) ? end.difference(start) : Duration.zero;

      return {
        'name': trk.name ?? 'Unnamed Activity',
        'distance': totalDistance,
        'duration': duration,
        'type': trk.type ?? '',
      };
    }
    return {};
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371e3; // meters
    final f1 = lat1 * (pi / 180);
    final f2 = lat2 * (pi / 180);
    final df = (lat2 - lat1) * (pi / 180);
    final dl = (lon2 - lon1) * (pi / 180);

    final a = sin(df / 2) * sin(df / 2) +
        cos(f1) * cos(f2) * sin(dl / 2) * sin(dl / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c / 1000; // km
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create / Edit Activity')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Activity Name'),
            ),
            TextFormField(
              controller: _distanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Distance (km)'),
            ),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type of Training'),
            ),
            const SizedBox(height: 24),

            // Import button
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Import from GPX'),
              onPressed: _importGpxAndFillForm,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Save button pressed')),
                );
              },
              child: const Text('Save Activity'),
            ),
          ],
        ),
      ),
    );
  }
}
