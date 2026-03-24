import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_sheet.dart';
import '../../weather_core/domain/weather_models.dart';
import '../../weather_core/domain/weather_repository.dart';

class LocationSearchSheet extends StatefulWidget {
  const LocationSearchSheet({
    super.key,
    required this.repository,
    required this.selectedLocation,
  });

  final WeatherRepository repository;
  final WeatherLocation selectedLocation;

  @override
  State<LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<LocationSearchSheet> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;
  List<WeatherLocation> _results = WeatherLocation.presets;
  bool _loading = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void _handleSearch(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.length < 2) {
      setState(() {
        _loading = false;
        _results = _filterPresets(query);
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 280), () async {
      setState(() {
        _loading = true;
      });
      final results = await widget.repository.searchLocations(query);
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _results = results;
      });
    });
  }

  List<WeatherLocation> _filterPresets(String query) {
    if (query.isEmpty) {
      return WeatherLocation.presets;
    }
    final lower = query.toLowerCase();
    return WeatherLocation.presets
        .where((location) {
          return location.name.toLowerCase().contains(lower) ||
              location.region.toLowerCase().contains(lower);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return AppSheetFrame(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 12),
              const AppSheetHandle(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Choose a UK location',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Search towns and cities, or pick a quick preset.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      onChanged: _handleSearch,
                      autofocus: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: 'Search UK town or city',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _results.length + (_loading ? 1 : 0),
                  separatorBuilder: (_, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (_loading && index == 0) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      );
                    }
                    final offset = _loading ? index - 1 : index;
                    final location = _results[offset];
                    final selected =
                        location.name == widget.selectedLocation.name &&
                        location.region == widget.selectedLocation.region;
                    return Semantics(
                      button: true,
                      selected: selected,
                      label: '${location.name}, ${location.subtitle}',
                      hint: selected
                          ? 'Current selected location'
                          : 'Double tap to choose this location',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () => Navigator.of(context).pop(location),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected
                                ? appSheetSurfaceFill(context, strong: true)
                                : appSheetSurfaceFill(context),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: selected
                                  ? AppPalette.sky.withValues(alpha: 0.45)
                                  : appSheetSurfaceBorder(context),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  color: appSheetSurfaceFill(
                                    context,
                                    strong: true,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.place_rounded,
                                  color: AppPalette.sky,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      location.name,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      location.subtitle,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppPalette.teal,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
