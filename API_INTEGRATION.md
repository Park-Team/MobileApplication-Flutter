# Integración API EzPark

## 🚀 **API Configurada**

La aplicación Flutter está ahora integrada con tu backend de Render:

**URL Base:** `https://ezpark-platform-prueba.onrender.com`

## 📡 **Endpoints Configurados**

### **Autenticación**
- `POST /auth/login` - Iniciar sesión
- `POST /auth/register` - Registrar usuario
- `POST /auth/logout` - Cerrar sesión
- `GET /auth/me` - Obtener usuario actual

### **Estacionamientos**
- `GET /parkings` - Obtener todos los estacionamientos
- `GET /parkings/{id}` - Obtener estacionamiento por ID
- `GET /parkings/nearby?lat={lat}&lng={lng}&radius={radius}` - Estacionamientos cercanos

### **Reservas**
- `GET /reservations/user/{userId}` - Reservas del usuario
- `POST /reservations` - Crear nueva reserva
- `PUT /reservations/{id}` - Actualizar reserva

### **Reseñas**
- `GET /reviews/parking/{parkingId}` - Reseñas de un estacionamiento
- `POST /reviews` - Crear nueva reseña

### **Tarjetas de Pago**
- `GET /payment-cards/user/{userId}` - Tarjetas del usuario
- `POST /payment-cards` - Guardar nueva tarjeta

## 🔑 **Autenticación**

La app usa **Bearer Token** en los headers:
```
Authorization: Bearer {jwt_token}
```

## 📋 **Formato de Respuesta Esperado**

Todas las respuestas deben seguir este formato:
```json
{
  "success": true,
  "data": { ... },
  "message": "Mensaje opcional"
}
```

Para errores:
```json
{
  "success": false,
  "message": "Descripción del error"
}
```

## 🛠 **Archivos Modificados**

1. **`lib/services/api_service.dart`** - Nuevo servicio HTTP
2. **`lib/providers/auth_provider.dart`** - Actualizado para usar API
3. **`lib/providers/parking_provider.dart`** - Integrado con API
4. **`lib/providers/reservation_provider.dart`** - Conectado a API
5. **`lib/widgets/payment_dialog.dart`** - Usa llamadas HTTP

## 🔧 **Para Probar**

1. **Asegúrate que tu API esté funcionando:**
   ```bash
   curl https://ezpark-platform-prueba.onrender.com/health
   ```

2. **Ejecuta la app:**
   ```bash
   flutter run
   ```

3. **La app se conectará automáticamente a tu API**

## ⚠️ **Notas Importantes**

- **MockDataService** ha sido eliminado completamente
- **Todas las operaciones son ahora HTTP requests reales**
- **Los tokens JWT se manejan automáticamente**
- **Manejo de errores incluido**

## 🎯 **Lo que funciona ahora**

✅ Login/registro con tu API  
✅ Carga de estacionamientos desde la API  
✅ Creación de reservas reales  
✅ Sistema de reseñas conectado  
✅ Gestión de tarjetas de pago  
✅ Autenticación con tokens  

¡Tu app Flutter está ahora completamente integrada con tu backend! 🚗💨
