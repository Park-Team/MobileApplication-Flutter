import 'package:flutter/material.dart';
import '../models/parking.dart';
import '../models/review.dart';
import '../services/api_service.dart';
import '../utils/debug_logger.dart';

class ParkingProvider extends ChangeNotifier {
  List<Parking> _parkings = [];
  Parking? _selectedParking;
  List<Review> _selectedParkingReviews = [];
  bool _isLoading = false;
  String? _error;

  List<Parking> get parkings => _parkings;
  Parking? get selectedParking => _selectedParking;
  List<Review> get selectedParkingReviews => _selectedParkingReviews;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Fetch all parkings
  Future<void> fetchParkings() async {
    _setLoading(true);    try {
      DebugLogger.log("Iniciando carga de estacionamientos desde datos simulados...", category: "ParkingProvider");
      _parkings = await ApiService.getAllParkings();
      DebugLogger.log("Estacionamientos cargados exitosamente: ${_parkings.length} encontrados", category: "ParkingProvider");
      
      if (_parkings.isEmpty) {
        _error = "No hay estacionamientos disponibles";
        DebugLogger.log("ADVERTENCIA: No se encontraron estacionamientos en los datos simulados", category: "ParkingProvider");
      } else {
        _error = null;
        // Imprimir algunos detalles para debug
        for (var i = 0; i < _parkings.length && i < 3; i++) {
          DebugLogger.log("Parking ${i+1}: ID=${_parkings[i].id}, Nombre=${_parkings[i].name}, Dirección=${_parkings[i].address}", category: "ParkingProvider");
        }
      }
    } catch (e) {
      _error = "Failed to load parkings: $e";
      DebugLogger.log("ERROR al cargar estacionamientos: $e", category: "ParkingProvider");
    } finally {
      _setLoading(false);
    }
  }
  // Fetch nearby parkings
  Future<void> fetchNearbyParkings(double latitude, double longitude) async {
    _setLoading(true);
    try {      // Por ahora, devolvemos todos los parkings ya que no tenemos geolocalización en los datos simulados
      _parkings = await ApiService.getAllParkings();
      _error = null;
    } catch (e) {
      _error = "Failed to load nearby parkings: $e";
      DebugLogger.log(_error ?? "Unknown error", category: "ParkingProvider");
    } finally {
      _setLoading(false);
    }
  }

  // Select a specific parking
  Future<void> selectParking(String parkingId) async {
    _setLoading(true);
    try {
      final parking = await ApiService.getParkingById(parkingId);
      if (parking != null) {
        _selectedParking = parking;
        await fetchParkingReviews(parkingId);
        _error = null;
      } else {
        _error = "Parking not found";
      }    } catch (e) {
      _error = "Failed to load parking details: $e";
      DebugLogger.log(_error ?? "Unknown error", category: "ParkingProvider");
    } finally {
      _setLoading(false);
    }
  }  // Fetch reviews for a specific parking
  Future<void> fetchParkingReviews(String parkingId) async {
    try {
      DebugLogger.logReviewInfo("Obteniendo reseñas para el estacionamiento ID: $parkingId");
      _selectedParkingReviews = await ApiService.getReviewsForParking(parkingId);
      
      // Verificar si hay reseñas y mostrar su contenido para debugging
      if (_selectedParkingReviews.isNotEmpty) {
        DebugLogger.log("📊 Se encontraron ${_selectedParkingReviews.length} reseñas", category: "ParkingProvider");
        
        // Imprimir detalles de la primera reseña para debug
        final firstReview = _selectedParkingReviews.first;
        DebugLogger.log("📝 Primera reseña - Usuario: ${firstReview.userName}, Rating: ${firstReview.rating}", category: "ParkingProvider");
        DebugLogger.log("📝 Comentario: '${firstReview.comment.length > 50 ? "${firstReview.comment.substring(0, 50)}..." : firstReview.comment}'", category: "ParkingProvider");
      } else {
        DebugLogger.logReviewInfo("No se encontraron reseñas para el estacionamiento $parkingId");
      }
      
      _error = null;
    } catch (e) {
      _error = "Failed to load reviews: $e";
      DebugLogger.logReviewError("Error al cargar las reseñas", e);
    }
    notifyListeners();
  }  // Add a review
  Future<void> addReview(String parkingId, String userId, String userName, String comment, double rating) async {
    try {
      _setLoading(true);
      DebugLogger.log("ParkingProvider: Añadiendo reseña - Usuario: $userName, Comentario: $comment, Rating: $rating", category: "ParkingProvider");
      
      final review = await ApiService.createReview(parkingId, userId, comment, rating);
      
      if (review != null) {
        // Verificar que el comentario se guardó correctamente
        DebugLogger.log("ParkingProvider: Reseña creada correctamente - ID: ${review.id}, Comentario: ${review.comment}", category: "ParkingProvider");
        
        // Agregar la nueva reseña a la lista local
        _selectedParkingReviews.add(review);
        _error = null;
        
        // Recargar los detalles del parking para obtener el rating actualizado
        if (_selectedParking != null) {
          final updatedParking = await ApiService.getParkingById(parkingId);
          if (updatedParking != null) {
            _selectedParking = updatedParking;
          }
        }
      } else {
        _error = "No se pudo añadir la reseña";
        DebugLogger.log("ParkingProvider: Error - No se pudo añadir la reseña", category: "ParkingProvider");
      }    } catch (e) {
      _error = "Error al añadir reseña: $e";
      DebugLogger.log(_error ?? "Unknown error", category: "ParkingProvider");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

