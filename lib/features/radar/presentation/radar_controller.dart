import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/rain_viewer_service.dart';

/// Manages radar frame data and the currently selected frame index.
class RadarState {
  const RadarState({
    this.mapData,
    this.currentFrameIndex = 0,
    this.isLoading = false,
    this.isPlaying = false,
    this.errorMessage,
  });

  final RainViewerMapData? mapData;
  final int currentFrameIndex;
  final bool isLoading;
  final bool isPlaying;
  final String? errorMessage;

  bool get hasData => mapData != null && mapData!.allFrames.isNotEmpty;

  List<RadarFrame> get frames => mapData?.allFrames ?? [];

  RadarFrame? get currentFrame =>
      hasData ? frames[currentFrameIndex] : null;

  bool get isNowcast =>
      mapData != null && currentFrameIndex >= mapData!.nowcastStartIndex;

  RadarState copyWith({
    RainViewerMapData? mapData,
    int? currentFrameIndex,
    bool? isLoading,
    bool? isPlaying,
    String? errorMessage,
  }) {
    return RadarState(
      mapData: mapData ?? this.mapData,
      currentFrameIndex: currentFrameIndex ?? this.currentFrameIndex,
      isLoading: isLoading ?? this.isLoading,
      isPlaying: isPlaying ?? this.isPlaying,
      errorMessage: errorMessage,
    );
  }
}

class RadarController extends Notifier<RadarState> {
  Timer? _playTimer;

  @override
  RadarState build() {
    ref.onDispose(() => _playTimer?.cancel());
    return const RadarState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final service = ref.read(rainViewerServiceProvider);
      final data = await service.fetchMapData();
      final frames = data.allFrames;
      // Start at the latest past frame (the "now" position).
      final initialIndex = (data.nowcastStartIndex - 1).clamp(0, frames.length - 1);
      state = state.copyWith(
        mapData: data,
        currentFrameIndex: initialIndex,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not load radar data.',
      );
    }
  }

  void seekTo(int index) {
    if (!state.hasData) return;
    state = state.copyWith(
      currentFrameIndex: index.clamp(0, state.frames.length - 1),
    );
  }

  void togglePlayback() {
    if (state.isPlaying) {
      _stopPlayback();
    } else {
      _startPlayback();
    }
  }

  void _startPlayback() {
    if (!state.hasData) return;
    state = state.copyWith(isPlaying: true);
    _playTimer?.cancel();
    _playTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      if (!state.hasData) {
        _stopPlayback();
        return;
      }
      final nextIndex = (state.currentFrameIndex + 1) % state.frames.length;
      state = state.copyWith(currentFrameIndex: nextIndex);
    });
  }

  void _stopPlayback() {
    _playTimer?.cancel();
    _playTimer = null;
    state = state.copyWith(isPlaying: false);
  }
}

final radarControllerProvider =
    NotifierProvider<RadarController, RadarState>(RadarController.new);
