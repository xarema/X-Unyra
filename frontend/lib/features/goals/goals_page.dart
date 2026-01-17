import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_state.dart';

import '../../repos/goals_repo.dart';
import 'goals_providers.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(goalsListProvider);
    await ref.read(goalsListProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(goalsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
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
              final g = list[index];
              return ListTile(
                title: Text(g.title),
                subtitle: Text(g.status),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => ListView(children: [Padding(padding: const EdgeInsets.all(16), child: Text('Erreur: $e'))]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(context: context, builder: (context) => const _CreateGoalDialog());
          ref.invalidate(goalsListProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CreateGoalDialog extends ConsumerStatefulWidget {
  const _CreateGoalDialog();

  @override
  ConsumerState<_CreateGoalDialog> createState() => _CreateGoalDialogState();
}

class _CreateGoalDialogState extends ConsumerState<_CreateGoalDialog> {
  String _title = '';
  String _why = '';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvel objectif'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(decoration: const InputDecoration(labelText: 'Titre'), onChanged: (v) => _title = v),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Pourquoi (pour nous)'),
            minLines: 2,
            maxLines: 5,
            onChanged: (v) => _why = v,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(
          onPressed: _busy || _title.trim().isEmpty
              ? null
              : () async {
                  setState(() => _busy = true);
                  try {
                    await ref.read(goalsRepoProvider).createGoal(title: _title.trim(), whyForUs: _why.trim());
                    if (context.mounted) Navigator.pop(context);
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                },
          child: const Text('Créer'),
        ),
      ],
    );
  }
}
