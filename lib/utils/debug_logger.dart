import 'dart:developer' as developer;

// Clase de utilidad para depurar con formato consistente
class DebugLogger {
  // Log para reseñas
  static void logReviewInfo(String message) {
    developer.log('[REVIEW_INFO] $message', name: 'ReviewDebug');
  }
  
  static void logReviewError(String message, [dynamic error]) {
    developer.log('[REVIEW_ERROR] $message ${error != null ? "- Error: $error" : ""}', 
      name: 'ReviewDebug', 
      error: error
    );
  }
  
  static void debugReview(Map<String, dynamic> reviewData) {
    try {
      final id = reviewData['_id']?.toString() ?? 'unknown';
      final parkingId = reviewData['parkingId']?.toString() ?? 'unknown';
      final userId = reviewData['userId']?.toString() ?? 'unknown';
      final userName = reviewData['userName']?.toString() ?? 'unknown';
      final rating = reviewData['rating']?.toString() ?? 'unknown';
      
      String comment = 'null';
      if (reviewData.containsKey('comment') && reviewData['comment'] != null) {
        final commentValue = reviewData['comment'];
        if (commentValue is String) {
          comment = commentValue;
        } else {
          comment = commentValue.toString();
        }
      }
        // Recortar el comentario si es muy largo
      if (comment.length > 100) {
        comment = "${comment.substring(0, 97)}...";
      }
      
      // Crear una representación visual
      final debugInfo = '''
=== REVIEW DEBUG ===
ID: $id
ParkingID: $parkingId
UserID: $userId
UserName: $userName
Rating: $rating
Comment: "$comment"
===================
''';
      developer.log(debugInfo, name: 'ReviewDebug');
    } catch (e) {
      developer.log('[ERROR] No se pudo depurar la reseña: $e', 
        name: 'ReviewDebug',
        error: e
      );
    }
  }
  
  // Log para reservaciones
  static void logReservationInfo(String message) {
    developer.log('[RESERVATION_INFO] $message', name: 'ReservationDebug');
  }
  
  static void logReservationError(String message, [dynamic error]) {
    developer.log('[RESERVATION_ERROR] $message ${error != null ? "- Error: $error" : ""}', 
      name: 'ReservationDebug', 
      error: error
    );
  }
  
  // Log para autenticación
  static void logAuthInfo(String message) {
    developer.log('[AUTH_INFO] $message', name: 'AuthDebug');
  }
  
  static void logAuthError(String message, [dynamic error]) {
    developer.log('[AUTH_ERROR] $message ${error != null ? "- Error: $error" : ""}', 
      name: 'AuthDebug', 
      error: error
    );
  }
    // Log general
  static void log(String message, {String? category, dynamic error}) {
    final String prefix = category != null ? '[$category] ' : '';
    developer.log('$prefix$message', name: 'EzParkDebug', error: error);
  }
}
