import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'providers.dart';

class CoupleApp extends ConsumerWidget {
  const CoupleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialiser l'authentification au démarrage
    ref.watch(authInitializationProvider);

    final router = ref.watch(appRouterProvider);


    return MaterialApp.router(
      title: 'Couple App',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}
