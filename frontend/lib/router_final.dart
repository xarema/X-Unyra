import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_screens.dart';
import 'features/pairing/pairing_screens.dart';
import 'features/home_shell.dart';
import 'core/providers_v2.dart';

/// Router provider utilisant Riverpod
final appRouterProvider = Provider<GoRouter>((ref) {
  /// Stream pour mettre à jour le router quand l'auth change
  final authStream = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // ===== Auth Routes =====
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

      // ===== Pairing Routes =====
      GoRoute(
        path: '/pairing',
        name: 'pairing',
        builder: (context, state) => const PairingScreen(),
      ),
      GoRoute(
        path: '/pairing/join',
        name: 'join',
        builder: (context, state) => const JoinCoupleScreen(),
      ),

      // ===== Home with nested routes =====
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeShell(),
      ),
    ],

    // Redirection basée sur l'état d'authentification
    redirect: (context, state) {
      // Vérifier si l'utilisateur est authentifié
      final isAuth = authStream.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      // Les pages accessibles sans auth
      final publicPages = ['/login', '/register'];
      final isPublicPage = publicPages.contains(state.matchedLocation);

      // Les pages nécessitant l'auth
      final privatePages = ['/pairing', '/pairing/join', '/home'];
      final isPrivatePage = privatePages.contains(state.matchedLocation);

      // Si pas authentifié et page privée → redirect to login
      if (!isAuth && isPrivatePage) {
        return '/login';
      }

      // Si authentifié et page publique → redirect to pairing
      if (isAuth && isPublicPage) {
        return '/pairing';
      }

      return null;
    },
  );
});
