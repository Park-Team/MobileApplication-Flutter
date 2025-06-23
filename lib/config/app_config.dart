import 'package:flutter/material.dart';

/// Configuración centralizada de la aplicación EzPark
/// Incluye todos los colores, estilos, constantes y configuraciones de la aplicación
class AppConfig {
  // ==================== INFORMACIÓN DE LA APP ====================
  static const String appName = 'EzPark';
  static const String appVersion = '1.0.0';
  
  // ==================== API CONFIGURATION ====================
  static const String apiBaseUrl = 'https://ezpark-platform-prueba.onrender.com';
  
  // ==================== ASSETS ====================
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String logoPath = 'assets/images/logo.png';
    // ==================== COLORES ====================
  // Colores principales de la marca
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryBlueDark = Color(0xFF1565C0);
  static const Color primaryBlueLight = Color(0xFF90CAF9);
  static const Color primaryGreen = Color(0xFF34A853);
  static const Color primaryGreenLight = Color(0xFF81C784);
  static const Color primaryGreenDark = Color(0xFF2E7D32);
  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color primaryYellow = Color(0xFFFDD835);
  static const Color primaryRed = Color(0xFFF44336);
  static const Color primaryWhite = Colors.white;
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textBody = Color(0xFF666666);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = Colors.white;
  
  // Colores de fondo
  static const Color backgroundPrimary = Colors.white;
  static const Color backgroundSecondary = Color(0xFFF8F9FA);
  static const Color backgroundTertiary = Color(0xFFF1F3F4);
  static const Color backgroundAccent = Color(0xFFE8F0FE);
  static const Color background = Colors.white;
  
  // Colores de cards y superficies
  static const Color cardBackground = Colors.white;
  static const Color cardBackgroundHover = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFFF5F5F5);
  
  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color errorRed = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color infoBlue = Color(0xFF2196F3);
  
  // Colores de UI
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFCCCCCC);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderColor = Color(0xFFCCCCCC);
  static const Color borderFocused = Color(0xFF4285F4);
  static const Color disabledInput = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  
  // Colores neutros
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);
  
  // Colores específicos para componentes
  static const Color primaryButton = Color(0xFF4285F4);
  static const Color buttonTextWhite = Colors.white;
  static const Color highlighted = Color(0xFF34A853);
  static const Color appBar = Color(0xFF4285F4);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  
  // ==================== TIPOGRAFÍA ====================
  static const String fontFamily = 'Roboto';
  
  // Tamaños de fuente
  static const double fontSizeXLarge = 28.0;
  static const double fontSizeLarge = 24.0;
  static const double fontSizeMedium = 18.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeXSmall = 12.0;
  
  // Pesos de fuente
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  
  // ==================== ESPACIADO ====================
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double marginXSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginXLarge = 32.0;
  
  // ==================== BORDES Y RADIOS ====================
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusCircular = 50.0;
  
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;
  
  // ==================== ELEVACIONES Y SOMBRAS ====================
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationMax = 16.0;
  
  // ==================== DIMENSIONES DE COMPONENTES ====================
  // Botones
  static const double buttonHeightSmall = 32.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
  
  // Inputs
  static const double inputHeight = 56.0;
  static const double inputBorderRadius = 8.0;
  
  // Cards
  static const double cardElevation = 2.0;
  static const double cardBorderRadius = 12.0;
  
  // App Bar
  static const double appBarHeight = 56.0;
  
  // ==================== ANIMACIONES ====================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // ==================== ICONOS Y ASSETS ====================
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;
  
  // ==================== RESTRICCIONES DE VALIDACIÓN ====================
  static const int passwordMinLength = 6;
  static const int nameMinLength = 2;
  static const int phoneNumberLength = 10;
  
  // ==================== CONFIGURACIONES DE UI ====================
  static const int maxParkingImages = 5;
  static const int maxReviewLength = 500;
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Alias para compatibilidad
  static Color get cardShadow => shadowLight;
  
  // Gradiente principal
  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryBlue, primaryBlueDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Decoración modal
  static BoxDecoration get modalDecoration => BoxDecoration(
    color: backgroundPrimary,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radiusLarge),
      topRight: Radius.circular(radiusLarge),
    ),
    boxShadow: [
      BoxShadow(
        color: shadowMedium,
        blurRadius: elevationHigh,
        offset: Offset(0, -elevationLow),
      ),
    ],
  );

  // ==================== HELPERS PARA THEME ====================
  /// Crea un MaterialColor a partir de un Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = (color.r * 255.0).round() & 0xff;
    final int g = (color.g * 255.0).round() & 0xff;
    final int b = (color.b * 255.0).round() & 0xff;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
  
  static TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize ?? fontSizeRegular,
      fontWeight: fontWeight ?? fontWeightRegular,
      color: color ?? textPrimary,
      letterSpacing: letterSpacing,
      height: height,
    );
  }
  
  static BoxDecoration getCardDecoration({
    Color? color,
    double? radius,
    double? elevation,
  }) {
    return BoxDecoration(
      color: color ?? cardBackground,
      borderRadius: BorderRadius.circular(radius ?? cardBorderRadius),
      boxShadow: elevation != null ? [
        BoxShadow(
          color: shadow,
          blurRadius: elevation,
          offset: Offset(0, elevation / 2),
        ),
      ] : null,
    );
  }
  
  static InputDecoration getInputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: primaryBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(inputBorderRadius),
        borderSide: BorderSide(color: error),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: paddingMedium,
        vertical: paddingMedium,
      ),
    );
  }
  
  // Alias para compatibilidad con código existente
  static const double subtitleFontSize = fontSizeLarge;
  static const double titleFontSize = fontSizeXLarge;
  static const double bodyFontSize = fontSizeRegular;
  static const double buttonFontSize = fontSizeMedium;
}
