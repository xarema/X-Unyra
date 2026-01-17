import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  final _codeController = TextEditingController();
  String? _errorMessage;
  String? _generatedCode;

  @override
  void initState() {
    super.initState();
    _loadCouple();
  }

  void _loadCouple() async {
    await ref.read(coupleProvider.notifier).getCouple();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _handleCreateCouple() async {
    setState(() => _errorMessage = null);
    final success = await ref.read(coupleProvider.notifier).createCouple();

    if (mounted) {
      if (success) {
        _showSuccessSnackbar('Couple créé avec succès!');
        setState(() {});
      } else {
        final error = ref.read(coupleProvider).error;
        setState(() => _errorMessage = error ?? 'Erreur lors de la création');
      }
    }
  }

  void _handleGenerateCode() async {
    setState(() => _errorMessage = null);
    final code = await ref.read(coupleProvider.notifier).generateInviteCode();

    if (mounted) {
      if (code != null) {
        setState(() => _generatedCode = code);
        _showSuccessSnackbar('Code généré: $code');
      } else {
        final error = ref.read(coupleProvider).error;
        setState(() => _errorMessage = error ?? 'Erreur lors de la génération');
      }
    }
  }

  void _handleJoinCouple() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMessage = 'Veuillez entrer un code');
      return;
    }

    setState(() => _errorMessage = null);
    final success = await ref.read(coupleProvider.notifier).joinCouple(code);

    if (mounted) {
      if (success) {
        _showSuccessSnackbar('Vous avez rejoint le couple!');
        context.go('/home');
      } else {
        final error = ref.read(coupleProvider).error;
        setState(() => _errorMessage = error ?? 'Code invalide');
      }
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coupleState = ref.watch(coupleProvider);
    final hasCouple = coupleState.couple != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appairage'),
        actions: [
          if (hasCouple)
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () => context.go('/couple'),
                child: Center(
                  child: Text(
                    'Afficher le couple',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32),
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
            const SizedBox(height: 32),
            if (!hasCouple) ...[
              const Text(
                'Créer un couple',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleCreateCouple,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Créer un nouveau couple'),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),
            ],
            if (hasCouple && _generatedCode == null) ...[
              const Text(
                'Inviter votre partenaire',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleGenerateCode,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Générer un code d\'invitation'),
              ),
              const SizedBox(height: 32),
            ],
            if (_generatedCode != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Code d\'invitation',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _generatedCode!,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Partagez ce code avec votre partenaire',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            const Text(
              'Rejoindre un couple',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Code d\'invitation',
                border: OutlineInputBorder(),
                hintText: '123456',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleJoinCouple,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Rejoindre le couple'),
            ),
          ],
        ),
      ),
    );
  }
}
