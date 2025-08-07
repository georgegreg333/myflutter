import 'dart:io';
import 'package:exif/exif.dart';

class CoordinateExtractor {
  static Future<Map<String, String>?> extractRawCoordinates(File imageFile) async {
    try {
      final exifData = await readExifFromFile(imageFile);

      if (exifData.containsKey('GPS GPSLatitude') && exifData.containsKey('GPS GPSLongitude')) {
        final lat = exifData['GPS GPSLatitude']?.printable;
        final lon = exifData['GPS GPSLongitude']?.printable;

        if (lat != null && lon != null) {
          return {
            'latitude': lat,
            'longitude': lon,
          };
        }
      }
    } catch (e) {
      print('Error reading EXIF GPS: $e');
    }

    return null;
  }
}
