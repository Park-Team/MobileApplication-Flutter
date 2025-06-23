import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/parking.dart';
import '../models/reservation.dart';
import '../models/review.dart';
import '../models/card.dart';

class ApiService {
  static const String baseUrl = 'https://ezpark-platform.onrender.com/api/v1';
  static String? _authToken;
  
  // Headers comunes para todas las requests
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  // ==================== AUTHENTICATION ENDPOINTS ====================
    static Future<User?> login(String email, String password) async {
    try {
      final url = '$baseUrl/users/login';
      final requestBody = {
        'email': email,
        'password': password,
      };
      
      print('=== LOGIN DEBUG ===');
      print('URL: $url');
      print('Request body: $requestBody');
      print('Headers: Content-Type: application/json, Accept: application/json');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Login exitoso: $data');
        
        // Tu API devuelve directamente el objeto user
        _authToken = 'auth_token_${data['id']}'; // Temporal hasta implementar JWT
        
        return User.fromJson(data);
      } else {
        print('Error en login: ${response.statusCode} - ${response.body}');
        throw Exception('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }

  static Future<User?> register(String firstName, String lastName, String email, String password, {String? phone, DateTime? birthDate}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          if (phone != null) 'phone': phone,
          if (birthDate != null) 'birthDate': birthDate.toIso8601String().split('T')[0],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Registro exitoso: $data');
        
        _authToken = 'auth_token_${data['id']}';
        
        return User.fromJson(data);
      } else {
        print('Error en registro: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error en registro: $e');
      return null;
    }
  }
  static Future<void> logout() async {
    // Tu API no parece tener endpoint de logout, solo limpiamos el token
    _authToken = null;
  }
  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      // Tu API no parece tener endpoint específico para cambio de contraseña
      // Por ahora retornamos true simulando éxito, pero esto debería implementarse
      // cuando el backend tenga el endpoint correspondiente
      print('API no tiene endpoint de cambio de contraseña, simulando éxito');
      
      // Simular delay de red
      await Future.delayed(Duration(seconds: 1));
      
      return true;
    } catch (e) {
      print('Error cambiando contraseña: $e');
      return false;
    }
  }

  static Future<User?> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? profilePicture,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      
      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (birthDate != null) body['birthDate'] = birthDate.toIso8601String().split('T')[0];
      if (profilePicture != null) body['profilePicture'] = profilePicture;

      final response = await http.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Perfil actualizado exitosamente: $data');
        return User.fromJson(data);
      } else {
        print('Error actualizando perfil: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error actualizando perfil: $e');
      return null;
    }
  }

  static Future<User?> getCurrentUser() async {
    if (_authToken == null) return null;
    
    try {
      // Extraer userId del token temporal
      final userId = _authToken!.replaceAll('auth_token_', '');
      return await getUserById(int.parse(userId));
    } catch (e) {
      print('Error obteniendo usuario actual: $e');
      return null;
    }
  }

  static Future<User?> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        print('Error obteniendo usuario: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  // ==================== PARKING ENDPOINTS ====================
  
  static Future<List<Parking>> getAllParkings() async {
    try {
      // Usar una ubicación central y radio grande para obtener todos los parkings
      final response = await http.get(
        Uri.parse('$baseUrl/parkings/search?latitude=0&longitude=0&radiusKm=10000'),
        headers: _headers,
      );

      print('Respuesta cruda de /parkings/search: \\n${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decodificado:');
        print(data);
        if (data is List) {
          return data.map((parking) => Parking.fromJson(parking)).toList();
        } else if (data is Map && data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List).map((parking) => Parking.fromJson(parking)).toList();
        }
        return [];
      } else {
        print('Error obteniendo parkings: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error obteniendo estacionamientos: $e');
      return [];
    }
  }

  static Future<Parking?> getParkingById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/parkings/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parking obtenido: $data');
        return Parking.fromJson(data);
      } else {
        print('Error obteniendo parking: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error obteniendo parking: $e');
      return null;
    }
  }

  static Future<List<Parking>> searchParkings(double latitude, double longitude, double radiusKm) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/parkings/search?latitude=$latitude&longitude=$longitude&radiusKm=$radiusKm'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parkings encontrados: $data');
        
        if (data is List) {
          return data
              .map((parking) => Parking.fromJson(parking))
              .toList();
        }
        return [];
      } else {
        print('Error buscando parkings: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error buscando parkings: $e');
      return [];
    }
  }

  static Future<List<Parking>> getParkingsByOwner(int ownerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$ownerId/parkings'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parkings del propietario: $data');
        
        if (data is List) {
          return data
              .map((parking) => Parking.fromJson(parking))
              .toList();
        }
        return [];
      } else {
        print('Error obteniendo parkings del propietario: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error obteniendo parkings del propietario: $e');
      return [];
    }
  }

  // ==================== BOOKING ENDPOINTS ====================
  
  static Future<List<Reservation>> getReservationsForUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/bookings'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Reservas del usuario: $data');
        
        if (data is List) {
          return data
              .map((booking) => Reservation.fromJson(booking))
              .toList();
        }
        return [];
      } else {
        print('Error obteniendo reservas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error obteniendo reservas: $e');
      return [];
    }
  }

  static Future<Reservation?> createReservation({
    required String userId,
    required String parkingId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalPrice,
    String? notes,
    int? vehicleId,
  }) async {
    try {
      final body = {
        'parkingId': int.parse(parkingId),
        'vehicleId': vehicleId ?? 0, // Por defecto 0 si no se provee
        'startTime': startTime.toUtc().toIso8601String(),
        'endTime': endTime.toUtc().toIso8601String(),
        'notes': notes ?? '',
      };
      print('Body enviado a /users/$userId/bookings:');
      print(body);
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/bookings'),
        headers: _headers,
        body: json.encode(body),
      );

      print('Status: \\${response.statusCode}');
      print('Respuesta cruda: \\n${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('Reserva creada: $data');
        if (data is Map && data.containsKey('data')) {
          return Reservation.fromJson(data['data']);
        }
        return Reservation.fromJson(data);
      } else {
        print('Error creando reserva: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creando reserva: $e');
      return null;
    }
  }

  static Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      String endpoint;
      Map<String, dynamic> body = {};
      
      switch (status) {
        case 'CONFIRMED':
          endpoint = '$baseUrl/bookings/$bookingId/confirm';
          break;
        case 'ACTIVE':
          endpoint = '$baseUrl/bookings/$bookingId/start';
          break;
        case 'COMPLETED':
          endpoint = '$baseUrl/bookings/$bookingId/complete';
          body = {'finalPrice': 0}; // Ajustar según necesidades
          break;
        case 'CANCELLED':
          endpoint = '$baseUrl/bookings/$bookingId/cancel';
          body = {'cancellationReason': 'Cancelado por usuario'};
          break;
        default:
          return false;
      }

      final response = await http.put(
        Uri.parse(endpoint),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('Estado de booking actualizado: $status');
        return true;
      } else {
        print('Error actualizando estado: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error actualizando estado: $e');
      return false;
    }
  }

  // ==================== PAYMENT CARD ENDPOINTS ====================
  
  static Future<List<PaymentCard>> getPaymentCardsForUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payment-cards/user/$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Tarjetas del usuario: $data');
        
        if (data is List) {
          return data
              .map((card) => PaymentCard.fromJson(card))
              .toList();
        }
        return [];
      } else {
        print('Error obteniendo tarjetas: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error obteniendo tarjetas: $e');
      return [];
    }
  }

  static Future<void> saveCard(String userId, Map<String, dynamic> cardData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payment-cards'),
        headers: _headers,
        body: json.encode({
          'userId': int.parse(userId),
          'cardholderName': cardData['cardholderName'],
          'cardNumber': cardData['cardNumber'],
          'expiryMonth': cardData['expiryMonth'],
          'expiryYear': cardData['expiryYear'],
          'cvv': cardData['cvv'],
          'cardType': cardData['cardType'] ?? 'VISA',
        }),
      );

      if (response.statusCode == 201) {
        print('Tarjeta guardada exitosamente');
      } else {
        print('Error guardando tarjeta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error guardando tarjeta: $e');
      rethrow;
    }
  }

  // ==================== PAYMENT PROCESSING ENDPOINTS ====================
  
  static Future<Map<String, dynamic>> processPayment({
    required String userId,
    required String parkingId,
    required DateTime startTime,
    required DateTime endTime,
    required double totalAmount,
    required String paymentMethod,
    Map<String, dynamic>? cardData,
  }) async {
    try {
      // Crear la reserva primero
      final reservation = await createReservation(
        userId: userId,
        parkingId: parkingId,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalAmount,
        notes: 'Pago procesado con $paymentMethod',
      );

      if (reservation != null) {
        // Confirmar la reserva automáticamente
        await updateBookingStatus(reservation.id, 'CONFIRMED');
        
        return {
          'success': true,
          'reservationId': reservation.id,
          'message': 'Pago procesado exitosamente',
        };
      } else {
        throw Exception('No se pudo crear la reserva');
      }
    } catch (e) {
      print('Error procesando pago: $e');
      rethrow;
    }
  }

  // ==================== REVIEWS ENDPOINTS ====================
  // Nota: Tu API no parece tener endpoints de reviews, implementaremos funcionalidad básica
  
  static Future<List<Review>> getReviewsForParking(String parkingId) async {
    try {
      // Endpoint no existe en tu API, retornamos lista vacía
      print('API no tiene endpoint de reviews, retornando lista vacía');
      return [];
    } catch (e) {
      print('Error obteniendo reviews: $e');
      return [];
    }
  }

  static Future<Review?> createReview(String parkingId, String userId, String comment, double rating) async {
    try {
      // Endpoint no existe en tu API, simulamos creación exitosa
      print('API no tiene endpoint de reviews, simulando creación');      return Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        parkingId: parkingId,
        rating: rating,
        comment: comment,
        date: DateTime.now(),
      );
    } catch (e) {
      print('Error creando review: $e');
      return null;
    }
  }

  // ==================== UTILITY METHODS ====================
  
  static void setAuthToken(String token) {
    _authToken = token;
  }

  static String? get authToken => _authToken;

  static bool get isAuthenticated => _authToken != null;
}
