import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;
  // Inicializar datos (ya no es necesario)
  void initializeData() {
    // No necesitamos inicializar datos simulados
  }

  // Sign in user
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _error = null;
    
    try {
      User? user = await ApiService.login(email, password);
      
      if (user != null) {
        _currentUser = user;
        await _secureStorage.write(key: 'user_email', value: email);
        _setLoading(false);
        return true;
      } else {
        _error = "Credenciales inválidas";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }  // Register user
  Future<bool> register(String firstName, String lastName, String email, String password, {String? phone, DateTime? birthDate}) async {
    _setLoading(true);
    _error = null;
    
    try {
      User? user = await ApiService.register(firstName, lastName, email, password, phone: phone, birthDate: birthDate);
      if (user != null) {
        _currentUser = user;
        await _secureStorage.write(key: 'user_email', value: email);
        _setLoading(false);
        return true;
      } else {
        _error = "Error en el registro";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Sign out user
  Future<void> signOut() async {
    _currentUser = null;
    await ApiService.logout();
    await _secureStorage.deleteAll();
    notifyListeners();
  }
  // Auto login if user data exists
  Future<void> tryAutoLogin() async {
    try {
      final email = await _secureStorage.read(key: 'user_email');
      if (email != null) {
        // Verificar con el token guardado si existe
        _currentUser = await ApiService.getCurrentUser();
        notifyListeners();
      }
    } catch (e) {
      // Si hay error, simplemente no hacer auto login
    }
  }  // Update user profile
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? profilePicture,
  }) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      User? updatedUser = await ApiService.updateProfile(
        userId: _currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        birthDate: birthDate,
        profilePicture: profilePicture,
      );
      
      if (updatedUser != null) {
        _currentUser = updatedUser;
        _setLoading(false);
        return true;
      } else {
        _error = "Error actualizando perfil";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }
  // Update profile image
  Future<bool> updateProfileImage(String imageUrl) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      // Update via API first
      User? updatedUser = await ApiService.updateProfile(
        userId: _currentUser!.id,
        profilePicture: imageUrl,
      );
      
      if (updatedUser != null) {
        _currentUser = updatedUser;
        _setLoading(false);
        return true;
      } else {
        _error = "Error actualizando imagen de perfil";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }
  // Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;
    
    _setLoading(true);
    _error = null;
    
    try {
      // For API-based password change, we would call the API here
      // Since the User model no longer stores password, we'll need to implement
      // this via the API service when the backend supports it
      bool success = await ApiService.changePassword(oldPassword, newPassword);
      
      if (success) {
        _setLoading(false);
        return true;
      } else {
        _error = "Error al cambiar la contraseña";
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _error = null;
    
    try {
      // En una app real, esto enviaría un email de reset
      await Future.delayed(Duration(seconds: 1)); // Simular delay
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
