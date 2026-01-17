import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_state.dart';

import '../../models/question.dart';
import '../../repos/qna_repo.dart';
import 'qna_providers.dart';

class QnaPage extends ConsumerWidget {
  const QnaPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(qnaListProvider);
    await ref.read(qnaListProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(qnaListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Q&A'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: asyncList.when(
          data: (list) => ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final q = list[index];
              return ListTile(
                title: Text(q.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(q.theme.isEmpty ? 'Q&A' : q.theme),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => _AnswerSheet(question: q),
                  );
                  ref.invalidate(qnaListProvider);
                },
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => ListView(children: [Padding(padding: const EdgeInsets.all(16), child: Text('Erreur: $e'))]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(context: context, builder: (context) => const _CreateQuestionDialog());
          ref.invalidate(qnaListProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CreateQuestionDialog extends ConsumerStatefulWidget {
  const _CreateQuestionDialog();

  @override
  ConsumerState<_CreateQuestionDialog> createState() => _CreateQuestionDialogState();
}

class _CreateQuestionDialogState extends ConsumerState<_CreateQuestionDialog> {
  String _text = '';
  String _theme = '';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle question'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Thème (optionnel)'), onChanged: (v) => _theme = v),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Question'),
            minLines: 2,
            maxLines: 5,
            onChanged: (v) => _text = v,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(
          onPressed: _busy || _text.trim().isEmpty
              ? null
              : () async {
                  setState(() => _busy = true);
                  try {
                    await ref.read(qnaRepoProvider).createQuestion(text: _text.trim(), theme: _theme.trim());
                    if (context.mounted) Navigator.pop(context);
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                },
          child: const Text('Créer'),
        )
      ],
    );
  }
}

class _AnswerSheet extends ConsumerStatefulWidget {
  final Question question;
  const _AnswerSheet({required this.question});

  @override
  ConsumerState<_AnswerSheet> createState() => _AnswerSheetState();
}

class _AnswerSheetState extends ConsumerState<_AnswerSheet> {
  String _status = 'ANSWERED';
  String _text = '';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.question.text, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _status,
            items: const [
              DropdownMenuItem(value: 'ANSWERED', child: Text('Répondu')),
              DropdownMenuItem(value: 'NEEDS_TIME', child: Text('Besoin de temps')),
              DropdownMenuItem(value: 'CLARIFY', child: Text('À clarifier')),
            ],
            onChanged: (v) => setState(() => _status = v ?? 'ANSWERED'),
            decoration: const InputDecoration(labelText: 'Statut'),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Ta réponse (optionnel)'),
            minLines: 2,
            maxLines: 6,
            onChanged: (v) => _text = v,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _busy
                ? null
                : () async {
                    setState(() => _busy = true);
                    try {
                      await ref.read(qnaRepoProvider).answerQuestion(
                            questionId: widget.question.id,
                            status: _status,
                            text: _text,
                          );
                      if (context.mounted) Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
            child: _busy
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Envoyer'),
          )
        ],
      ),
    );
  }
}
