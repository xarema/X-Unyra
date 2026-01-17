import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/services/api_service.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Couple App - Simple Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TestPage(),
    );
  }
}

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TestPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _status = '';
  String _coupleInfo = '';
  String _accessToken = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _status = 'Connexion en cours...');

    try {
      final apiService = ApiService();
      final response = await apiService.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _accessToken = response['access'] ?? '';
      setState(() => _status = '✅ Connexion réussie!');

      await _getCouple();
    } catch (e) {
      setState(() => _status = '❌ Erreur: $e');
    }
  }

  void _getCouple() async {
    if (_accessToken.isEmpty) {
      setState(() => _coupleInfo = 'Pas de token');
      return;
    }

    try {
      final apiService = ApiService();
      final response = await apiService.getCouple();

      setState(() {
        _coupleInfo = 'Couple trouvé! ${response.toString().substring(0, 100)}...';
      });
    } catch (e) {
      setState(() => _coupleInfo = '❌ Pas de couple: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Couple App - Test Simple')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'alice@example.com'),
            ),
            const SizedBox(height: 16),
            const Text('PASSWORD', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'testpass123'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('SE CONNECTER'),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(
                'Status: $_status',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey[200],
              child: Text(
                'Couple: $_coupleInfo',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
