import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Captures a widget rendered offscreen as a PNG and shares it via the
/// platform share sheet.
class ShareCardService {
  const ShareCardService();

  /// Captures the widget behind [boundaryKey] at 3× resolution, writes it to
  /// a temporary file, and opens the platform share sheet.
  ///
  /// [text] is included as the share-sheet message alongside the image.
  Future<void> shareFromBoundary(
    GlobalKey boundaryKey, {
    String text = '',
  }) async {
    final boundary =
        boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      return;
    }

    final pngBytes = byteData.buffer.asUint8List();
    await _shareImageBytes(pngBytes, text: text);
  }

  Future<void> _shareImageBytes(
    Uint8List pngBytes, {
    required String text,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${tempDir.path}/dry_slots_share_$timestamp.png');
    await file.writeAsBytes(pngBytes);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'image/png')],
      text: text,
    );
  }
}
