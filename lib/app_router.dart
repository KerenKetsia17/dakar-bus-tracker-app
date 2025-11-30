
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_screen.dart';
import 'admin_screen.dart';
import 'passenger_screen.dart';
import 'driver_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (BuildContext context, GoRouterState state) => const AdminScreen(),
      ),
      GoRoute(
        path: '/passenger',
        builder: (BuildContext context, GoRouterState state) => const PassengerScreen(),
      ),
      GoRoute(
        path: '/driver',
        builder: (BuildContext context, GoRouterState state) => const DriverScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page non trouvée: ${state.error}'),
      ),
    ),
  );
}
