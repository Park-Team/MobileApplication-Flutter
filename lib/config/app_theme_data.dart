import 'package:flutter/material.dart';
import 'app_config.dart';

/// Tema de la aplicación EzPark usando la configuración consolidada
class AppThemeData {
  /// Tema principal de la aplicación
  static ThemeData get lightTheme {
    return ThemeData(
      // Configuración básica
      useMaterial3: true,
      fontFamily: AppConfig.fontFamily,
        // Color scheme
      colorScheme: ColorScheme.light(
        primary: AppConfig.primaryBlue,
        primaryContainer: AppConfig.primaryBlueLight,
        secondary: AppConfig.primaryGreen,
        secondaryContainer: AppConfig.primaryGreenLight,
        surface: AppConfig.backgroundPrimary,
        error: AppConfig.error,
        onPrimary: AppConfig.textOnPrimary,
        onSecondary: AppConfig.textOnPrimary,
        onSurface: AppConfig.textPrimary,
        onError: AppConfig.textOnPrimary,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: AppConfig.backgroundPrimary,
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppConfig.primaryBlue,
        foregroundColor: AppConfig.textOnDark,
        elevation: AppConfig.elevationMedium,
        centerTitle: true,
        titleTextStyle: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeLarge,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textOnDark,
        ),
      ),
      
      // Botones elevados (primarios)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.primaryBlue,
          foregroundColor: AppConfig.textOnPrimary,
          elevation: AppConfig.elevationLow,
          padding: EdgeInsets.symmetric(
            horizontal: AppConfig.paddingLarge,
            vertical: AppConfig.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
          ),
          textStyle: AppConfig.getTextStyle(
            fontSize: AppConfig.fontSizeMedium,
            fontWeight: AppConfig.fontWeightMedium,
          ),
        ),
      ),
      
      // Botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConfig.primaryBlue,
          padding: EdgeInsets.symmetric(
            horizontal: AppConfig.paddingMedium,
            vertical: AppConfig.paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
          ),
          textStyle: AppConfig.getTextStyle(
            fontSize: AppConfig.fontSizeMedium,
            fontWeight: AppConfig.fontWeightMedium,
          ),
        ),
      ),
      
      // Botones outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConfig.primaryBlue,
          side: BorderSide(color: AppConfig.primaryBlue),
          padding: EdgeInsets.symmetric(
            horizontal: AppConfig.paddingLarge,
            vertical: AppConfig.paddingMedium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusMedium),
          ),
          textStyle: AppConfig.getTextStyle(
            fontSize: AppConfig.fontSizeMedium,
            fontWeight: AppConfig.fontWeightMedium,
          ),
        ),
      ),
      
      // Campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConfig.backgroundPrimary,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppConfig.paddingMedium,
          vertical: AppConfig.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.borderFocused, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConfig.inputBorderRadius),
          borderSide: BorderSide(color: AppConfig.disabledInput),
        ),
        hintStyle: AppConfig.getTextStyle(
          color: AppConfig.textHint,
          fontSize: AppConfig.fontSizeRegular,
        ),
        labelStyle: AppConfig.getTextStyle(
          color: AppConfig.textSecondary,
          fontSize: AppConfig.fontSizeRegular,
        ),
      ),
        // Cards
      cardTheme: CardThemeData(
        color: AppConfig.cardBackground,
        elevation: AppConfig.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.cardBorderRadius),
        ),
        margin: EdgeInsets.all(AppConfig.marginSmall),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: AppConfig.divider,
        thickness: AppConfig.borderWidthThin,
        space: AppConfig.paddingMedium,
      ),
      
      // Tipografía
      textTheme: TextTheme(
        displayLarge: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeXLarge,
          fontWeight: AppConfig.fontWeightBold,
          color: AppConfig.textPrimary,
        ),
        displayMedium: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeLarge,
          fontWeight: AppConfig.fontWeightBold,
          color: AppConfig.textPrimary,
        ),
        displaySmall: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeMedium,
          fontWeight: AppConfig.fontWeightBold,
          color: AppConfig.textPrimary,
        ),
        headlineLarge: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeLarge,
          fontWeight: AppConfig.fontWeightSemiBold,
          color: AppConfig.textPrimary,
        ),
        headlineMedium: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeMedium,
          fontWeight: AppConfig.fontWeightSemiBold,
          color: AppConfig.textPrimary,
        ),
        headlineSmall: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeRegular,
          fontWeight: AppConfig.fontWeightSemiBold,
          color: AppConfig.textPrimary,
        ),
        titleLarge: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeLarge,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textPrimary,
        ),
        titleMedium: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeMedium,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textPrimary,
        ),
        titleSmall: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeRegular,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textPrimary,
        ),
        bodyLarge: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeMedium,
          fontWeight: AppConfig.fontWeightRegular,
          color: AppConfig.textPrimary,
        ),
        bodyMedium: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeRegular,
          fontWeight: AppConfig.fontWeightRegular,
          color: AppConfig.textPrimary,
        ),
        bodySmall: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeSmall,
          fontWeight: AppConfig.fontWeightRegular,
          color: AppConfig.textSecondary,
        ),
        labelLarge: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeMedium,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textPrimary,
        ),
        labelMedium: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeRegular,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textSecondary,
        ),
        labelSmall: AppConfig.getTextStyle(
          fontSize: AppConfig.fontSizeSmall,
          fontWeight: AppConfig.fontWeightMedium,
          color: AppConfig.textSecondary,
        ),
      ),
    );
  }
}
