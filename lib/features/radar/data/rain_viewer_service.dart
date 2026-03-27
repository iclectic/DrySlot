import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Fetches available radar tile timestamps from the RainViewer API.
///
/// RainViewer is free, requires no API key, and provides global precipitation
/// radar data with ~10-minute temporal resolution.
///
/// API docs: https://www.rainviewer.com/api.html
class RainViewerService {
  RainViewerService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  static const _mapsUrl = 'https://api.rainviewer.com/public/weather-maps.json';

  /// Returns radar frame metadata (past + nowcast) sorted chronologically.
  Future<RainViewerMapData> fetchMapData() async {
    final response = await _dio.get<Map<String, dynamic>>(_mapsUrl);
    final data = response.data;
    if (data == null) {
      throw Exception('RainViewer returned empty response');
    }

    final host = data['host'] as String? ?? 'https://tilecache.rainviewer.com';
    final radar = data['radar'] as Map<String, dynamic>? ?? {};
    final pastFrames = _parseFrames(radar['past']);
    final nowcastFrames = _parseFrames(radar['nowcast']);

    return RainViewerMapData(
      host: host,
      pastFrames: pastFrames,
      nowcastFrames: nowcastFrames,
    );
  }

  List<RadarFrame> _parseFrames(dynamic raw) {
    if (raw is! List) {
      return [];
    }
    return raw
        .whereType<Map<String, dynamic>>()
        .map((frame) => RadarFrame(
              time: DateTime.fromMillisecondsSinceEpoch(
                (frame['time'] as int) * 1000,
                isUtc: true,
              ),
              path: frame['path'] as String,
            ))
        .toList(growable: false)
      ..sort((a, b) => a.time.compareTo(b.time));
  }
}

class RadarFrame {
  const RadarFrame({required this.time, required this.path});

  final DateTime time;
  final String path;

  /// Builds a tile URL for a standard slippy-map tile coordinate.
  ///
  /// [host] is the RainViewer CDN host.
  /// [size] is the tile size (256 or 512).
  /// [colorScheme] selects the colour palette (0–8).
  /// [smooth] enables bilinear interpolation.
  /// [snow] enables snow detection overlay.
  String tileUrl({
    required String host,
    int size = 512,
    int colorScheme = 2,
    bool smooth = true,
    bool snow = true,
  }) {
    final smoothFlag = smooth ? 1 : 0;
    final snowFlag = snow ? 1 : 0;
    return '$host$path/$size/{z}/{x}/{y}/$colorScheme/${smoothFlag}_$snowFlag.png';
  }
}

class RainViewerMapData {
  const RainViewerMapData({
    required this.host,
    required this.pastFrames,
    required this.nowcastFrames,
  });

  final String host;
  final List<RadarFrame> pastFrames;
  final List<RadarFrame> nowcastFrames;

  /// All frames (past + nowcast) in chronological order.
  List<RadarFrame> get allFrames => [...pastFrames, ...nowcastFrames];

  /// Index of the first nowcast frame in [allFrames], or -1 if none.
  int get nowcastStartIndex => pastFrames.length;
}

final rainViewerServiceProvider = Provider<RainViewerService>((ref) {
  return RainViewerService();
});
