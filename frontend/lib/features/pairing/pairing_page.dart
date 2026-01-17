import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client.dart';

class PairingPage extends ConsumerStatefulWidget {
  const PairingPage({super.key});

  @override
  ConsumerState<PairingPage> createState() => _PairingPageState();
}

class _PairingPageState extends ConsumerState<PairingPage> {
  bool _busy = false;
  String? _coupleId;
  bool _isPaired = false;
  String? _inviteCode;
  String _joinCode = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _busy = true);
    final dio = ref.read(dioProvider);
    try {
      final res = await dio.get('/couple/');
      final couple = res.data['couple'] as Map<String, dynamic>;
      final partnerB = couple['partner_b'];
      setState(() {
        _coupleId = couple['id']?.toString();
        _isPaired = partnerB != null;
      });
    } catch (_) {
      setState(() {
        _coupleId = null;
        _isPaired = false;
        _inviteCode = null;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createCouple() async {
    setState(() => _busy = true);
    final dio = ref.read(dioProvider);
    try {
      await dio.post('/couple/create/');
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _createInvite() async {
    setState(() => _busy = true);
    final dio = ref.read(dioProvider);
    try {
      final res = await dio.post('/couple/invite/', data: {'ttl_minutes': 120});
      final invite = res.data['invite'] as Map<String, dynamic>;
      setState(() => _inviteCode = invite['code']?.toString());
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _joinCouple() async {
    setState(() => _busy = true);
    final dio = ref.read(dioProvider);
    try {
      await dio.post('/couple/join/', data: {'code': _joinCode});
      await _refresh();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _goHome() => context.go('/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pairing'),
        actions: [
          IconButton(onPressed: _busy ? null : _refresh, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _busy
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Statut', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(_coupleId == null ? 'Pas encore de couple.' : 'Couple: $_coupleId'),
                      Text(_isPaired ? '✅ Paired' : '⏳ En attente de partenaire'),
                      const SizedBox(height: 16),
                      if (_coupleId == null)
                        FilledButton.icon(
                          onPressed: _createCouple,
                          icon: const Icon(Icons.favorite),
                          label: const Text('Créer notre couple'),
                        ),
                      if (_coupleId != null && !_isPaired)
                        FilledButton.icon(
                          onPressed: _createInvite,
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Générer un code d\'invitation'),
                        ),
                      if (_inviteCode != null) ...[
                        const SizedBox(height: 12),
                        SelectableText('Code: $_inviteCode', style: Theme.of(context).textTheme.headlineSmall),
                        const Text('Envoie ce code à ton/ta partenaire.'),
                      ],
                      const Divider(height: 32),
                      Text('Rejoindre un couple', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Code (6 chiffres)'),
                        onChanged: (v) => _joinCode = v.trim(),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(onPressed: _joinCode.isEmpty ? null : _joinCouple, child: const Text('Rejoindre')),
                      const Spacer(),
                      FilledButton(
                        onPressed: _coupleId != null ? _goHome : null,
                        child: const Text('Continuer'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
