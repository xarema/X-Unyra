import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_state.dart';

import '../../repos/letters_repo.dart';
import 'letters_providers.dart';

class LettersPage extends ConsumerWidget {
  const LettersPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(currentLetterProvider);
    await ref.read(currentLetterProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLetter = ref.watch(currentLetterProvider);
    final month = currentMonth();

    return Scaffold(
      appBar: AppBar(title: Text('Lettre $month')),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: asyncLetter.when(
          data: (letter) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Écris une lettre mensuelle (vous pouvez la remplir petit à petit).',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => _LetterEditorPage(initial: letter?.content ?? '', month: month)),
                  );
                  ref.invalidate(currentLetterProvider);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Éditer'),
              ),
              const SizedBox(height: 12),
              Text(letter?.content.isNotEmpty == true ? letter!.content : '(vide)'),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => ListView(children: [Padding(padding: const EdgeInsets.all(16), child: Text('Erreur: $e'))]),
        ),
      ),
    );
  }
}

class _LetterEditorPage extends ConsumerStatefulWidget {
  final String initial;
  final String month;
  const _LetterEditorPage({required this.initial, required this.month});

  @override
  ConsumerState<_LetterEditorPage> createState() => _LetterEditorPageState();
}

class _LetterEditorPageState extends ConsumerState<_LetterEditorPage> {
  late final TextEditingController _controller;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await ref.read(lettersRepoProvider).upsert(month: widget.month, content: _controller.text);
      if (mounted) Navigator.pop(context);
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
      appBar: AppBar(
        title: Text('Éditer ${widget.month}'),
        actions: [
          TextButton(onPressed: _busy ? null : _save, child: const Text('Sauver')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Votre lettre...'),
        ),
      ),
    );
  }
}
