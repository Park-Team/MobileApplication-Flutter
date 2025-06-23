import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/ez_park_button.dart';
import '../services/image_upload_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isChangingPassword = false;
  bool _isEditMode = false; // Estado para controlar si estamos en modo edición
  File? _selectedImage; // Para almacenar la imagen seleccionada
  bool _isUploadingImage = false; // Para mostrar un estado de carga al subir la imagen

  @override  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        _nameController.text = authProvider.currentUser!.name; // Uses computed property
        _emailController.text = authProvider.currentUser!.email;
        // You might want to add separate controllers for firstName and lastName if editing them separately
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  // Toggle entre el modo de visualización y el modo de edición
  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      
      // Si salimos del modo de edición, limpiamos los campos de contraseña
      if (!_isEditMode) {
        _isChangingPassword = false;
        _passwordController.clear();
        _confirmPasswordController.clear();
        _selectedImage = null; // Clear selected image if cancelling edit
      }
    });
  }

  // Método para seleccionar una imagen (cámara o galería)
  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galería'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context);
                  await _getImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Obtener imagen desde la galería
  Future<void> _getImageFromGallery() async {
    final File? image = await ImageUploadService.pickImageFromGallery();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  // Obtener imagen desde la cámara
  Future<void> _getImageFromCamera() async {
    final File? image = await ImageUploadService.takePhoto();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }
  // Guardar la imagen de perfil
  Future<void> _saveProfileImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingImage = true;
    });
    
    try {
      // Guardar la imagen en el almacenamiento local
      final String? savedImagePath = await ImageUploadService.saveImageToLocalStorage(_selectedImage!);
      
      if (savedImagePath != null) {
        final String imageUrl = ImageUploadService.filePathToUrl(savedImagePath);
        
        // Actualizar la imagen de perfil en la base de datos
        if (mounted) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final success = await authProvider.updateProfileImage(imageUrl);
          
          if (success) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Imagen de perfil actualizada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authProvider.error ?? 'Error al actualizar la imagen de perfil'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la imagen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingImage = false;
        });
      }
    }
  }
  
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_isChangingPassword && _passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Mostrar diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Actualizando perfil...")
              ],
            ),
          );
        },
      );
      
      try {
        // Primero guardamos la imagen si hay una nueva seleccionada
        if (_selectedImage != null) {
          await _saveProfileImage();
        }        // Split the name into first and last name
        final nameParts = _nameController.text.trim().split(' ');
        final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
        final lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';
        
        final success = await authProvider.updateProfile(
          firstName: firstName,
          lastName: lastName,
          email: _emailController.text.trim(),
        );
        
        // Cerrar el diálogo de carga
        if (mounted) Navigator.of(context).pop();

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          // Salir del modo de edición después de guardar cambios
          _toggleEditMode();
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Error al actualizar el perfil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Cerrar el diálogo de carga en caso de error no manejado
        if (mounted) Navigator.of(context).pop();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error inesperado: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
    // Método que construye los widgets para el modo de edición
  List<Widget> _buildEditModeContent(AuthProvider authProvider) {
    return [

      // MODO EDICIÓN      // Username Field
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Nombre de Usuario:',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: _nameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu nombre de usuario';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),
      
      // Email Field
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Correo electrónico:',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 8.0),
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingresa tu correo electrónico';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Por favor ingresa un correo válido';
          }
          return null;
        },
      ),
      const SizedBox(height: 16.0),

      // Change Password Option
      CheckboxListTile(
        title: Text(
          'Cambiar Contraseña',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        value: _isChangingPassword,
        onChanged: (value) {
          setState(() {
            _isChangingPassword = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      
      // Password Fields cuando se está cambiando la contraseña
      if (_isChangingPassword) ...[
        const SizedBox(height: 8.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Nueva contraseña:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isPasswordVisible,
          validator: (value) {
            if (_isChangingPassword) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa una contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16.0),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Confirmar contraseña:',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _confirmPasswordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),
          obscureText: !_isConfirmPasswordVisible,
          validator: (value) {
            if (_isChangingPassword) {
              if (value == null || value.isEmpty) {
                return 'Por favor confirma tu contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
            }
            return null;
          },
        ),
      ],
    ];
  }
  // Método que construye los widgets para el modo de visualización
  List<Widget> _buildViewModeContent(AuthProvider authProvider) {
    return [
        // MODO VISUALIZACIÓN
      // Nombre de usuario (username)
      Text(
        authProvider.currentUser?.name ?? 'Usuario',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8.0),
      
      // Email
      Text(
        authProvider.currentUser?.email ?? 'correo@ejemplo.com',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    ];
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const EzParkAppBar(
        title: 'Mi Perfil',
        showMenu: false, // No mostrar el botón de menú, sino el de retroceso
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              
              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,                        width: 2.0,
                      ),
                      image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          )
                        : authProvider.currentUser?.profilePicture != null
                          ? DecorationImage(
                              image: NetworkImage(authProvider.currentUser!.profilePicture!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage != null || authProvider.currentUser?.profilePicture != null
                        ? null
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  
                  // Solo mostrar el botón para cambiar la foto en modo edición
                  if (_isEditMode)
                    _isUploadingImage 
                      ? Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                            onPressed: _selectImage,
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ),
                ],
              ),
              
              const SizedBox(height: 24.0),
              
              // El contenido cambia según el modo (edición o visualización)
              ..._isEditMode ? _buildEditModeContent(authProvider) : _buildViewModeContent(authProvider),
              
              const SizedBox(height: 40.0),
              
              // Botón "Editar perfil" o "Guardar cambios" según el modo
              EzParkButton(
                text: _isEditMode ? 'Guardar cambios' : 'Editar perfil',
                onPressed: _isEditMode ? _saveChanges : _toggleEditMode,
                isLoading: authProvider.isLoading,
              ),
              
              // Botón para cancelar la edición si estamos en modo edición
              if (_isEditMode) 
                TextButton(
                  onPressed: _toggleEditMode,
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
