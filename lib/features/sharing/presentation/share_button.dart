import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/share_card_service.dart';
import '../../../core/theme/app_theme.dart';
import 'shareable_card.dart';

/// A small share icon button that, when tapped, renders the associated
/// [ShareableCardVariant] offscreen, captures it as a PNG, and opens the
/// platform share sheet.
class ShareCardButton extends StatefulWidget {
  const ShareCardButton({
    super.key,
    required this.variant,
    this.iconSize = 20,
  });

  final ShareableCardVariant variant;
  final double iconSize;

  @override
  State<ShareCardButton> createState() => _ShareCardButtonState();
}

class _ShareCardButtonState extends State<ShareCardButton> {
  final _boundaryKey = GlobalKey();
  bool _sharing = false;
  OverlayEntry? _overlayEntry;

  Future<void> _share() async {
    if (_sharing) {
      return;
    }
    setState(() => _sharing = true);

    // Insert the shareable card offscreen so we can capture it.
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: -9999,
        top: -9999,
        child: Material(
          color: Colors.transparent,
          child: ShareableCard(
            boundaryKey: _boundaryKey,
            variant: widget.variant,
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);

    // Wait a frame so the overlay paints.
    await Future<void>.delayed(const Duration(milliseconds: 120));

    try {
      const service = ShareCardService();
      await service.shareFromBoundary(
        _boundaryKey,
        text: widget.variant.shareText,
      );
    } finally {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() => _sharing = false);
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Share this card',
      child: Tooltip(
        message: 'Share',
        child: InkWell(
          onTap: _sharing ? null : () => unawaited(_share()),
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _sharing
                ? SizedBox(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.ios_share_rounded,
                    size: widget.iconSize,
                    color: AppPalette.sky,
                  ),
          ),
        ),
      ),
    );
  }
}
