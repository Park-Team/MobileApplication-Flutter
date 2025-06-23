import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/parking_provider.dart';
import 'providers/reservation_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/parking_details_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/reservations_screen.dart';
import 'config/app_config.dart';
import 'config/app_theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations and system UI
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppConfig.backgroundPrimary,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Ya no necesitamos inicializar datos simulados
  // La app se conectará directamente a la API
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ParkingProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        initialRoute: '/login',routes: {          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/home': (context) => const HomeScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/reservations': (context) => const ReservationsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/parking-details') {
            final parkingId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ParkingDetailsScreen(parkingId: parkingId),
            );
          } else if (settings.name == '/parking-reviews') {
            final parkingId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ReviewsScreen(parkingId: parkingId),
            );
          }
          return null;
        },
      ),
    );  }
}
