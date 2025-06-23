# Configuración de la Aplicación EzPark

## Estructura Optimizada

La configuración de la aplicación EzPark ha sido completamente optimizada y consolidada en dos archivos principales:

### 📁 lib/config/

#### 1. `app_config.dart` - Configuración Central
Este archivo contiene toda la configuración de la aplicación:

- **Información de la App**: Nombre, versión, URL de API
- **Colores**: Paleta completa de colores (primarios, texto, fondo, estado, UI)
- **Tipografía**: Fuentes, tamaños y pesos
- **Espaciado**: Padding, márgenes y dimensiones
- **Bordes y Radios**: Radio de bordes, grosores
- **Elevaciones y Sombras**: Niveles de elevación
- **Animaciones**: Duraciones estándar
- **Validaciones**: Restricciones para formularios
- **Helpers**: Métodos utilitarios para estilos

#### 2. `app_theme_data.dart` - Tema de Flutter
Este archivo define el tema completo de Material Design utilizando `app_config.dart`:

- **ColorScheme**: Esquema de colores Material 3
- **Tipografía**: TextTheme completo
- **Componentes**: Estilos para AppBar, botones, inputs, cards, etc.

## Beneficios de la Optimización

### ✅ Antes (9 archivos redundantes)
- `app_colors.dart`
- `app_theme.dart`
- `app_theme_clean.dart`
- `app_theme_final.dart`
- `app_theme_new.dart`
- `app_theme_simple.dart`
- `constants.dart`
- `styles.dart`
- `app_config.dart`

### ✅ Después (2 archivos optimizados)
- `app_config.dart` - **Configuración central**
- `app_theme_data.dart` - **Tema Material**

## Uso

### Importación
```dart
import '../config/app_config.dart';          // Para constantes y colores
import '../config/app_theme_data.dart';      // Para el tema (solo en main.dart)
```

### Ejemplos de Uso

#### Colores
```dart
Container(
  color: AppConfig.primaryBlue,
  child: Text(
    'Texto',
    style: TextStyle(color: AppConfig.textWhite),
  ),
)
```

#### Espaciado
```dart
Container(
  padding: EdgeInsets.all(AppConfig.paddingMedium),
  margin: EdgeInsets.symmetric(vertical: AppConfig.marginLarge),
)
```

#### Estilos de Texto
```dart
Text(
  'Título',
  style: AppConfig.getTextStyle(
    fontSize: AppConfig.fontSizeLarge,
    fontWeight: AppConfig.fontWeightBold,
    color: AppConfig.textPrimary,
  ),
)
```

#### Decoraciones
```dart
Container(
  decoration: AppConfig.getCardDecoration(
    radius: AppConfig.radiusLarge,
    elevation: AppConfig.elevationMedium,
  ),
)
```

#### Inputs
```dart
TextField(
  decoration: AppConfig.getInputDecoration(
    hintText: 'Ingresa tu email',
    prefixIcon: Icon(Icons.email),
  ),
)
```

## Constantes Disponibles

### Colores Principales
- `AppConfig.primaryBlue` - Color principal
- `AppConfig.primaryGreen` - Color secundario
- `AppConfig.primaryRed` - Color de error
- `AppConfig.primaryWhite` - Blanco

### Colores de Texto
- `AppConfig.textPrimary` - Texto principal
- `AppConfig.textSecondary` - Texto secundario
- `AppConfig.textHint` - Texto de hint

### Tamaños de Fuente
- `AppConfig.fontSizeXLarge` - 28px
- `AppConfig.fontSizeLarge` - 24px
- `AppConfig.fontSizeMedium` - 18px
- `AppConfig.fontSizeRegular` - 16px
- `AppConfig.fontSizeSmall` - 14px

### Espaciado
- `AppConfig.paddingXLarge` - 32px
- `AppConfig.paddingLarge` - 24px
- `AppConfig.paddingMedium` - 16px
- `AppConfig.paddingSmall` - 8px

### Radios
- `AppConfig.radiusXLarge` - 16px
- `AppConfig.radiusLarge` - 12px
- `AppConfig.radiusMedium` - 8px
- `AppConfig.radiusSmall` - 4px

## Mantenimiento

### ✅ Ventajas
- **Una sola fuente de verdad**: Todos los valores están centralizados
- **Fácil mantenimiento**: Cambios en un solo lugar
- **Consistencia**: Mismos valores en toda la aplicación
- **Escalabilidad**: Fácil agregar nuevos valores
- **Legibilidad**: Código más limpio y comprensible

### ⚠️ Importante
- **Solo modificar**: `app_config.dart` para cambios de configuración
- **No duplicar**: Evitar crear nuevos archivos de configuración
- **Usar helpers**: Utilizar los métodos utilitarios proporcionados
- **Mantener compatibilidad**: No eliminar constantes existentes sin verificar su uso

## Migración Completada

✅ **Archivos eliminados**:
- Todos los archivos redundantes de configuración
- Imports obsoletos actualizados

✅ **Archivos actualizados**:
- `main.dart` - Usa `AppThemeData.lightTheme`
- `home_screen.dart` - Usa `AppConfig`
- `payment_screen.dart` - Usa `AppConfig`
- `time_slot_selection_dialog.dart` - Usa `AppConfig`

✅ **Resultado**:
- Configuración consolidada y optimizada
- Código más limpio y mantenible
- Fácil escalabilidad para futuras funcionalidades
