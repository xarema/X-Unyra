import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers.dart';
import '../../core/providers.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  @override
  Widget build(BuildContext context) {
    final couple = ref.watch(coupleNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Formation du couple')),
      body: couple.when(
        data: (coupleData) {
          if (coupleData != null) {
            // Couple déjà formé
            return _CoupleFormedView(couple: coupleData);
          } else {
            // Pas de couple, proposer de créer ou rejoindre
            return _NoCoupleView();
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
    );
  }
}

class _NoCoupleView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: Colors.pinkAccent),
          const SizedBox(height: 32),
          const Text(
            'Pas encore appairé',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Créez un couple ou rejoignez un partenaire',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await ref.read(coupleNotifierProvider.notifier).createCouple();
              },
              icon: const Icon(Icons.add),
              label: const Text('Créer un couple'),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/pairing/join'),
              icon: const Icon(Icons.person_add),
              label: const Text('Rejoindre un couple'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoupleFormedView extends StatelessWidget {
  final couple;

  const _CoupleFormedView({required this.couple});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Icon(Icons.favorite, size: 80, color: Colors.red),
          const SizedBox(height: 32),
          const Text(
            'Couple formé!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Partenaire A',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    couple.partnerA.username,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (couple.partnerB != null) ...[
                    const Text(
                      'Partenaire B',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      couple.partnerB.username,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ] else ...[
                    const Text(
                      'En attente du partenaire B...',
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Continuer'),
            ),
          ),
        ],
      ),
    );
  }
}

class JoinCoupleScreen extends ConsumerStatefulWidget {
  const JoinCoupleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JoinCoupleScreen> createState() => _JoinCoupleScreenState();
}

class _JoinCoupleScreenState extends ConsumerState<JoinCoupleScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer un code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(coupleNotifierProvider.notifier).joinCouple(code);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rejoindre un couple')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 32),
            const Text(
              'Entrez le code d\'invitation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Demandez le code à votre partenaire',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: '000000',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Code d\'invitation',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 4),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _join,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Rejoindre'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
