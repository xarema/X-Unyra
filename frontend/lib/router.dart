import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/couple/screens/pairing_screen.dart';
import 'features/home/screens/home_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: auth.isAuthenticated ? '/couple' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/couple',
        name: 'couple',
        builder: (context, state) => const PairingScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeShell(),
      ),
    ],
    redirect: (context, state) {
      final isAuth = auth.isAuthenticated;
      final loc = state.matchedLocation;

      if (!isAuth) {
        // Non authentifié
        if (loc == '/login' || loc == '/register') {
          return null; // Rester sur la page
        }
        return '/login'; // Rediriger vers login
      }

      // Authentifié
      if (loc == '/login' || loc == '/register') {
        return '/couple'; // Aller directement au couple
      }

      return null; // Laisser passer
    },
  );
});



