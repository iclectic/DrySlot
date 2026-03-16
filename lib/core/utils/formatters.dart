String formatTemperature(num value) => '${value.round()}°';

String formatPercent(num value) => '${value.round()}%';

String formatRain(num mm) {
  if (mm <= 0.04) {
    return 'Trace';
  }
  final precision = mm < 1 ? 1 : 0;
  return '${mm.toStringAsFixed(precision)} mm';
}

String formatWind(num kph) => '${(kph * 0.621371).round()} mph';

String formatVisibility(num meters) {
  final km = meters / 1000;
  return km < 10 ? '${km.toStringAsFixed(1)} km' : '${km.round()} km';
}

String formatDurationShort(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0 && minutes > 0) {
    return '${hours}h ${minutes}m';
  }
  if (hours > 0) {
    return '${hours}h';
  }
  return '${duration.inMinutes}m';
}

String formatClock(DateTime time) {
  final hour = time.hour == 0
      ? 12
      : time.hour > 12
      ? time.hour - 12
      : time.hour;
  final suffix = time.hour >= 12 ? 'pm' : 'am';
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $suffix';
}

String formatCompactClock(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String formatTimeRange(DateTime start, DateTime end) {
  return '${formatCompactClock(start)} to ${formatCompactClock(end)}';
}

String formatUpdated(DateTime time) => 'Updated ${formatClock(time)}';

String formatDateHeader(DateTime time) {
  const weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  const months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${weekdays[time.weekday - 1]} ${time.day} ${months[time.month - 1]}';
}
