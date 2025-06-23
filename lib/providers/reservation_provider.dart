import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../services/api_service.dart';

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];
  bool _isLoading = false;
  String? _error;

  List<Reservation> get reservations => _reservations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Métodos de filtrado por estado
  List<Reservation> get activeReservations => _reservations
      .where((reservation) => reservation.status == 'active')
      .toList();

  List<Reservation> get completedReservations => _reservations
      .where((reservation) => reservation.status == 'completed')
      .toList();

  List<Reservation> get cancelledReservations => _reservations
      .where((reservation) => reservation.status == 'cancelled')
      .toList();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Cargar reservas del usuario
  Future<void> loadUserReservations(String userId) async {
    _setLoading(true);
    _error = null;

    try {
      _reservations = await ApiService.getReservationsForUser(userId);
      // Ordenar por fecha de inicio (más reciente primero)
      _reservations.sort((a, b) => b.startTime.compareTo(a.startTime));
      notifyListeners();
    } catch (e) {
      _error = "Error loading reservations: $e";
    } finally {
      _setLoading(false);
    }
  }
  // Crear una nueva reserva
  Future<bool> createReservation({
    required String userId,
    required String parkingId,
    required DateTime startTime,
    required DateTime endTime,
    required double pricePerHour,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Calcular precio total
      final hours = endTime.difference(startTime).inMinutes / 60;
      final totalPrice = hours * pricePerHour;      // Verificar si existe una reserva adyacente (que termina cuando esta empieza o empieza cuando esta termina)
      final adjacentReservations = _reservations
          .where((r) =>
              r.parkingId.toString() == parkingId &&
              r.status == 'ACTIVE' &&
              (r.endTime.isAtSameMomentAs(startTime) ||
                  r.startTime.isAtSameMomentAs(endTime)))
          .toList();

      if (adjacentReservations.isNotEmpty) {
        // Si hay una reserva adyacente, extenderla en lugar de crear una nueva
        final existingReservation = adjacentReservations.first;
        
        final newStartTime = existingReservation.startTime.isBefore(startTime)
            ? existingReservation.startTime
            : startTime;
            
        final newEndTime = existingReservation.endTime.isAfter(endTime)
            ? existingReservation.endTime
            : endTime;
            
        final newTotalHours = newEndTime.difference(newStartTime).inMinutes / 60;        final additionalPrice = newTotalHours * pricePerHour - existingReservation.priceTotal;
        
        final success = await updateReservationTimes(
          reservationId: existingReservation.id,
          newStartTime: newStartTime,
          newEndTime: newEndTime,
          additionalPrice: additionalPrice,        );

        if (success) {
          await loadUserReservations(userId);
          return true;
        }
        return false;
      }      // Si no hay reservas adyacentes, crear una nueva
      final newReservation = await ApiService.createReservation(
        userId: userId,
        parkingId: parkingId,
        startTime: startTime,
        endTime: endTime,
        totalPrice: totalPrice,
      );
      
      if (newReservation != null) {
        _reservations.add(newReservation);
        _reservations.sort((a, b) => b.startTime.compareTo(a.startTime));
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _error = "Error creating reservation: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }
  // Extender una reserva existente
  Future<bool> updateReservationTimes({
    required String reservationId,
    required DateTime newStartTime,
    required DateTime newEndTime,
    required double additionalPrice,
  }) async {
    _setLoading(true);
    _error = null;

    try {
      // Encontrar la reserva
      final reservationIndex = _reservations.indexWhere((r) => r.id == reservationId);
      if (reservationIndex == -1) {
        _setError("Reservation not found");
        return false;
      }

      final oldReservation = _reservations[reservationIndex];
      
      // Simular actualización exitosa
      await Future.delayed(Duration(milliseconds: 300));
        // Actualizar en la memoria local
      _reservations[reservationIndex] = oldReservation.copyWith(
        startTime: newStartTime,
        endTime: newEndTime,
        totalPrice: oldReservation.totalPrice + additionalPrice,
      );
      notifyListeners();
      return true;
    } catch (e) {
      _error = "Error extending reservation: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cancelar una reserva
  Future<bool> cancelReservation(String reservationId) async {
    _setLoading(true);
    _error = null;

    try {
      // Simular cancelación exitosa
      await Future.delayed(Duration(milliseconds: 300));
      
      // Actualizar en memoria local
      final index = _reservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _reservations[index] = _reservations[index].copyWith(
          status: 'cancelled',
        );
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _error = "Error cancelling reservation: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Marcar reserva como completada
  Future<bool> completeReservation(String reservationId) async {
    _setLoading(true);
    _error = null;

    try {
      // Simular completado exitoso
      await Future.delayed(Duration(milliseconds: 300));
      
      // Actualizar en memoria local
      final index = _reservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        _reservations[index] = _reservations[index].copyWith(
          status: 'completed',
        );
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _error = "Error completing reservation: $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
