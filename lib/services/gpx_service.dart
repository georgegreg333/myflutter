import 'dart:io';
import 'dart:math';
import 'package:gpx/gpx.dart';

class GpxSummary {
  final String name;
  final double distanceKm;
  final Duration duration;
  final String type;

  GpxSummary({
    required this.name,
    required this.distanceKm,
    required this.duration,
    required this.type,
  });
}

class GpxService {
  Future<GpxSummary> parseGpxFile(File file) async {
    final gpxString = await file.readAsString();
    final xmlGpx = GpxReader().fromString(gpxString);

    if (xmlGpx.trks.isEmpty) {
      throw Exception('No track data found');
    }

    final trk = xmlGpx.trks.first;
    final points = trk.trksegs.expand((seg) => seg.trkpts).toList();

    if (points.length < 2) {
      throw Exception('Not enough points to calculate data.');
    }

    double totalDistance = 0.0;
    DateTime? startTime = points.first.time;
    DateTime? endTime = points.last.time;

    for (int i = 1; i < points.length; i++) {
      final p1 = points[i - 1];
      final p2 = points[i];
      totalDistance += _haversine(p1.lat!, p1.lon!, p2.lat!, p2.lon!);
    }

    final duration = (startTime != null && endTime != null)
        ? endTime.difference(startTime)
        : Duration.zero;

    return GpxSummary(
      name: trk.name ?? 'Unnamed',
      distanceKm: totalDistance,
      duration: duration,
      type: trk.type ?? 'Unknown',
    );
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
