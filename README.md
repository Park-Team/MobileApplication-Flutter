# EzPark

Una aplicación móvil desarrollada con Flutter para la reserva de estacionamientos.

## Características principales

- **Autenticación de usuarios**: Registro, inicio de sesión y recuperación de contraseña.
- **Exploración de estacionamientos**: Buscar estacionamientos disponibles.
- **Sistema de reservas**: Crear, ver y gestionar reservas de estacionamiento.
- **Perfiles de usuario**: Gestión de la información de perfil y foto de perfil.
- **Reseñas y valoraciones**: Valorar estacionamientos y dejar comentarios.
- **Fusión inteligente de reservas**: Combinación automática de reservas consecutivas.

## Tecnologías

- **Frontend**: Flutter
- **Backend**: Servicio MongoDB
- **Gestión de estado**: Provider
- **Base de datos**: MongoDB Atlas
- **Almacenamiento seguro**: Flutter Secure Storage
- **Manejo de imágenes**: Image Picker, Path Provider

## Estructura del proyecto

```
lib/
  ├── config/               # Configuración de la aplicación
  │   ├── constants.dart    # Constantes globales
  │   ├── styles.dart       # Estilos globales
  │   └── theme.dart        # Configuración del tema
  │
  ├── models/               # Modelos de datos
  │   ├── parking.dart      # Modelo para estacionamientos
  │   ├── reservation.dart  # Modelo para reservas
  │   ├── review.dart       # Modelo para reseñas
  │   └── user.dart         # Modelo para usuarios
  │
  ├── providers/            # Providers para gestión del estado
  │   ├── auth_provider.dart        # Gestión de autenticación
  │   ├── parking_provider.dart     # Gestión de estacionamientos
  │   └── reservation_provider.dart # Gestión de reservas
  │
  ├── screens/              # Pantallas de la aplicación
  │   ├── edit_profile_screen.dart   # Edición de perfil
  │   ├── home_screen.dart           # Pantalla principal
  │   ├── login_screen.dart          # Inicio de sesión
  │   ├── parking_details_screen.dart # Detalles de estacionamiento
  │   └── ...
  │
  ├── services/             # Servicios externos
  │   ├── image_upload_service.dart  # Servicio de subida de imágenes
  │   └── mongodb_service.dart       # Servicio de MongoDB
  │
  ├── utils/                # Utilidades
  │   ├── app_utils.dart           # Utilidades generales
  │   ├── date_time_formatter.dart # Formateadores de fecha/hora
  │   └── debug_logger.dart        # Utilidades de depuración
  │
  ├── widgets/              # Widgets reutilizables
  │   ├── app_bar.dart             # AppBar personalizado
  │   ├── ez_park_button.dart      # Botón personalizado
  │   └── ...
  │
  └── main.dart            # Punto de entrada de la aplicación
```

## Instalación

1. Asegúrate de tener Flutter instalado. Si no, sigue las instrucciones en [flutter.dev](https://flutter.dev/docs/get-started/install).

2. Clona el repositorio:
```bash
git clone https://github.com/usuario/ezpark.git
```

3. Instala las dependencias:
```bash
cd ezpark
flutter pub get
```

4. Ejecuta la aplicación:
```bash
flutter run
```

## Configuración de MongoDB

La aplicación utiliza MongoDB Atlas como base de datos. Para conectar a tu propia instancia:

1. Crea una cuenta en [MongoDB Atlas](https://www.mongodb.com/cloud/atlas).
2. Configura un nuevo clúster.
3. Actualiza la cadena de conexión en `lib/config/constants.dart`.

## Contribución

¡Las contribuciones son bienvenidas! Por favor, abre un issue o envía una pull request para sugerencias o correcciones.
