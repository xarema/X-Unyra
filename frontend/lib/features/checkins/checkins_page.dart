import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/auth_state.dart';

import '../../repos/checkins_repo.dart';
import 'checkins_providers.dart';

class CheckinsPage extends ConsumerWidget {
  const CheckinsPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(checkinsProvider);
    await ref.read(checkinsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncList = ref.watch(checkinsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
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
              final c = list[index];
              return ListTile(
                title: Text('${c.date.toLocal().toIso8601String().substring(0, 10)}  Mood ${c.mood}/10'),
                subtitle: Text('Stress ${c.stress}/10  Energie ${c.energy}/10'),
              );
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => ListView(children: [Padding(padding: const EdgeInsets.all(16), child: Text('Erreur: $e'))]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(context: context, builder: (context) => const _CheckInDialog());
          ref.invalidate(checkinsProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _CheckInDialog extends ConsumerStatefulWidget {
  const _CheckInDialog();

  @override
  ConsumerState<_CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends ConsumerState<_CheckInDialog> {
  int _mood = 5;
  int _stress = 5;
  int _energy = 5;
  String _note = '';
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Check-in aujourd\'hui'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SliderRow(label: 'Mood', value: _mood, onChanged: (v) => setState(() => _mood = v)),
          _SliderRow(label: 'Stress', value: _stress, onChanged: (v) => setState(() => _stress = v)),
          _SliderRow(label: 'Energie', value: _energy, onChanged: (v) => setState(() => _energy = v)),
          TextField(decoration: const InputDecoration(labelText: 'Note (optionnel)'), onChanged: (v) => _note = v),
        ],
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.pop(context), child: const Text('Annuler')),
        FilledButton(
          onPressed: _busy
              ? null
              : () async {
                  setState(() => _busy = true);
                  try {
                    await ref.read(checkinsRepoProvider).createToday(
                          mood: _mood,
                          stress: _stress,
                          energy: _energy,
                          note: _note,
                        );
                    if (context.mounted) Navigator.pop(context);
                  } finally {
                    if (mounted) setState(() => _busy = false);
                  }
                },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  const _SliderRow({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            label: value.toString(),
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(width: 28, child: Text('$value')),
      ],
    );
  }
}
