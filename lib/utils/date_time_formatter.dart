import 'package:intl/intl.dart';

/// Clase de utilidades para formatear fechas y horas
class DateTimeFormatter {
  /// Formatea una fecha y hora en formato dd/MM/yyyy HH:mm
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  
  /// Formatea sólo la fecha en formato dd/MM/yyyy
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
  
  /// Formatea sólo la hora en formato HH:mm
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }
  
  /// Formatea una duración entre dos fechas en formato legible (ej: "2h 30min")
  static String formatDuration(DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    } else if (hours > 0) {
      return '$hours h';
    } else {
      return '$minutes min';
    }
  }
  
  /// Calcula la duración en horas entre dos fechas (como número decimal)
  static double calculateHoursBetween(DateTime startTime, DateTime endTime) {
    final difference = endTime.difference(startTime);
    return difference.inMinutes / 60;
  }
  
  /// Comprueba si dos fechas son el mismo día
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
  
  /// Comprueba si una fecha está entre otras dos fechas
  static bool isDateBetween(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start) && date.isBefore(end) || date.isAtSameMomentAs(start) || date.isAtSameMomentAs(end);
  }
  
  /// Genera las franjas horarias disponibles para un día
  static List<DateTime> generateTimeSlots({
    required DateTime date,
    required List<int> availableHours,
    int interval = 15, // intervalo en minutos
  }) {
    final List<DateTime> slots = [];
    
    for (int hour in availableHours) {
      // Por cada hora disponible, crear slots por intervalos
      for (int minute = 0; minute < 60; minute += interval) {
        final slot = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          minute,
        );
        slots.add(slot);
      }
    }
    
    return slots;
  }
}
