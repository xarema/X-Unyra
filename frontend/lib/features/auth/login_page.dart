import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isRegister = false;
  bool _busy = false;
  String _username = '';
  String _password = '';
  String _email = '';

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;
    form.save();

    setState(() => _busy = true);
    final auth = ref.read(authStateProvider.notifier);
    try {
      if (_isRegister) {
        await auth.register(username: _username, password: _password, email: _email.isEmpty ? null : _email);
      } else {
        await auth.login(username: _username, password: _password);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Couple App')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_isRegister ? 'Créer un compte' : 'Connexion', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (v) => _username = (v ?? '').trim(),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
                  ),
                  const SizedBox(height: 12),
                  if (_isRegister)
                    Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Email (optionnel)'),
                          onSaved: (v) => _email = (v ?? '').trim(),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => _password = (v ?? '').trim(),
                    validator: (v) => (v == null || v.length < 4) ? 'Min 4 caractères' : null,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy ? null : _submit,
                    child: _busy
                        ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_isRegister ? 'Créer' : 'Se connecter'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _busy ? null : () => setState(() => _isRegister = !_isRegister),
                    child: Text(_isRegister ? 'Déjà un compte ? Se connecter' : 'Pas de compte ? Créer'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
