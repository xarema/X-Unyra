import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    debugPrint('🚀 Login button pressed');
    debugPrint('   Email: $email');

    if (email.isEmpty || password.isEmpty) {
      debugPrint('❌ Email or password is empty');
      setState(() => _errorMessage = 'Email et mot de passe requis');
      return;
    }

    try {
      debugPrint('📞 Calling authProvider.login()');
      final success = await ref.read(authProvider.notifier).login(email, password);

      debugPrint('🔍 Login result: $success');

      if (mounted) {
        if (success) {
          debugPrint('✅ Login successful, loading couple data...');

          // Forcer une mise à jour du router en relavant le provider
          await Future.delayed(const Duration(milliseconds: 100));

          // Charger le couple
          debugPrint('📞 Calling coupleProvider.getCouple()');
          await ref.read(coupleProvider.notifier).getCouple();

          // Forcer la mise à jour de la route
          if (mounted) {
            debugPrint('🔄 Navigating to /couple');
            context.go('/couple');
          }
        } else {
          final error = ref.read(authProvider).error;
          debugPrint('❌ Login failed: $error');
          setState(() => _errorMessage = error ?? 'Connexion échouée');
        }
      }
    } catch (e) {
      debugPrint('💥 Exception during login: $e');
      if (mounted) {
        setState(() => _errorMessage = 'Erreur: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Couple App',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red[900]),
                  ),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/register'),
                child: const Text('Pas encore de compte? S\'inscrire'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
