import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImageUploadService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }
  
  /// Take a photo with the camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }
  
  /// Alias for pickImageFromCamera
  static Future<File?> takePhoto() async {
    return pickImageFromCamera();
  }
  
  /// Upload an image to storage and return the URL
  static Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      // In a real app, this would upload to a server or cloud storage
      // For now, we'll simulate by saving to local storage
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = '${userId}_${basename(imageFile.path)}';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      
      // Return the local path as a placeholder for a real URL
      return savedImage.path;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
  
  /// Save image to local storage (similar to uploadImage but without user ID)
  static Future<String?> saveImageToLocalStorage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'ezpark_profile_${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';
      final savedImage = await imageFile.copy('${appDir.path}/$fileName');
      return savedImage.path;
    } catch (e) {
      debugPrint('Error saving image to local storage: $e');
      return null;
    }
  }
  
  /// Convert a file path to a URL format for storage in database
  static String filePathToUrl(String filePath) {
    // In a real app, this would be a conversion to a real URL
    // For now, we'll just return the file path with a file:// prefix
    // or just the path itself depending on the app's architecture
    return 'file://$filePath';
  }
  
  /// Delete an image from storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      // In a real app, this would delete from a server or cloud storage
      // For now, we'll simulate by deleting from local storage
      
      // If it's a file:// URL, strip that prefix
      final filePath = imageUrl.startsWith('file://') 
          ? imageUrl.substring(7)  // Remove 'file://' prefix
          : imageUrl;
      
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting image: $e');
      return false;
    }
  }
}
