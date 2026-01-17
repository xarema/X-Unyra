import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/goals_models.dart';
import '../../../providers.dart';

class GoalsScreen extends ConsumerStatefulWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends ConsumerState<GoalsScreen> {
  final _goalTitleController = TextEditingController();
  final _goalWhyController = TextEditingController();
  String _selectedStatus = 'ACTIVE';

  @override
  void dispose() {
    _goalTitleController.dispose();
    _goalWhyController.dispose();
    super.dispose();
  }

  void _showCreateGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau but'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _goalTitleController,
                decoration: const InputDecoration(
                  labelText: 'Titre du but',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _goalWhyController,
                decoration: const InputDecoration(
                  labelText: 'Pourquoi c\'est important pour nous?',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (_goalTitleController.text.isNotEmpty) {
                // TODO: Créer le but via l'API
                _goalTitleController.clear();
                _goalWhyController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('But créé!')),
                );
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nos Buts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Goals Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('À implémenter avec les providers'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGoalDialog,
        tooltip: 'Nouveau but',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget pour afficher un seul but avec ses actions
class GoalTile extends ConsumerWidget {
  final Goal goal;

  const GoalTile({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StatusBadge(status: goal.status),
              ],
            ),
            const SizedBox(height: 8),
            if (goal.whyForUs.isNotEmpty)
              Text(
                goal.whyForUs,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            const SizedBox(height: 12),
            if (goal.actions.isNotEmpty) ...[
              const Text(
                'Actions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              for (var action in goal.actions)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: action.done,
                        onChanged: (value) {
                          // TODO: Mettre à jour l'action via l'API
                        },
                      ),
                      Expanded(
                        child: Text(
                          action.text,
                          style: TextStyle(
                            decoration: action.done
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'ACTIVE' => (Colors.green, 'Actif'),
      'DONE' => (Colors.blue, 'Fait'),
      'PAUSED' => (Colors.orange, 'Pausé'),
      _ => (Colors.grey, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
