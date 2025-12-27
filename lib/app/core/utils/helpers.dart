import 'package:intl/intl.dart';

class Helpers {
  static String formatTemperature(double temp) => '${temp.round()}°C';
  
  static String formatDate(DateTime date) => DateFormat('MMM dd, yyyy').format(date);
  
  static String formatDateRange(DateTime start, DateTime end) {
    return '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}';
  }
  
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}').join(' ');
  }
  
  static String getCategoryIcon(String cat) {
    final icons = {'cultural': '🏛️', 'historic': '🏰', 'natural': '🌲', 'religion': '⛪', 'amusements': '🎢', 'foods': '🍽️'};
    return icons[cat.toLowerCase()] ?? '📍';
  }
}
