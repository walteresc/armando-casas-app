import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/nueva_solicitud_screen.dart';
import '../screens/seguimiento_screen.dart';
import '../screens/calificacion_screen.dart';
import '../models/models.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String nuevaSolicitud = '/nueva-solicitud';
  static const String seguimiento = '/seguimiento';
  static const String calificacion = '/calificacion';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);
      case login:
        return _fadeRoute(const LoginScreen(), settings);
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      case nuevaSolicitud:
        return _slideRoute(const NuevaSolicitudScreen(), settings);
      case seguimiento:
        final solicitud = settings.arguments as Solicitud;
        return _slideRoute(SeguimientoScreen(solicitud: solicitud), settings);
      case calificacion:
        final solicitud = settings.arguments as Solicitud;
        return _slideRoute(CalificacionScreen(solicitud: solicitud), settings);
      default:
        return _fadeRoute(const SplashScreen(), settings);
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
