import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppUtils {
  // Formateadores de moneda
  static String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'es_MX',
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }
  
  // Calculador de duración en formato legible
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
  
  // Mostrar un SnackBar con un mensaje
  static void showSnackBar(BuildContext context, String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  // Mostrar un SnackBar con un mensaje de error
  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context, 
      message,
      backgroundColor: Colors.red.shade900,
    );
  }
  
  // Mostrar un SnackBar con un mensaje de éxito
  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context, 
      message,
      backgroundColor: Colors.green.shade800,
    );
  }
  
  // Validar email con expresión regular
  static bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }
  
  // Validar contraseña (mínimo 6 caracteres)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
  
  // Comparar dos fechas ignorando la hora
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  // Comprobar si una hora está dentro de un rango
  static bool isTimeInRange(DateTime time, DateTime start, DateTime end) {
    return time.isAfter(start) && time.isBefore(end) || time.isAtSameMomentAs(start) || time.isAtSameMomentAs(end);
  }
  
  // Obtener el color según el estado de la reserva
  static Color getReservationStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.blue.shade700;
      case 'completed':
        return Colors.green.shade700;
      case 'cancelled':
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }
}
