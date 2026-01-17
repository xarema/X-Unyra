import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers_v2.dart';

/// Screen Q&A
class QnaScreen extends ConsumerWidget {
  const QnaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: questions.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('Pas encore de questions'),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final question = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (question.theme.isNotEmpty)
                        Text(
                          question.theme,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        question.text,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('${question.answers.length} réponses'),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateQuestion(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateQuestion(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle question'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Votre question...',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(createQuestionProvider(controller.text).future);
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.refresh(questionsProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

/// Screen Goals
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Objectifs')),
      body: goals.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('Pas encore d\'objectifs'),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final goal = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(goal.status),
                            backgroundColor:
                                goal.status == 'ACTIVE' ? Colors.green : Colors.grey,
                          ),
                        ],
                      ),
                      if (goal.whyForUs.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(goal.whyForUs),
                      ],
                      const SizedBox(height: 12),
                      Text('${goal.actions.length} actions'),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoal(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGoal(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final whyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvel objectif'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Titre...',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: whyController,
              decoration: const InputDecoration(
                hintText: 'Pourquoi pour nous?',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(createGoalProvider(titleController.text).future);
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.refresh(goalsProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}

/// Screen Check-ins
class CheckInsScreen extends ConsumerWidget {
  const CheckInsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkins = ref.watch(checkinsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in quotidien')),
      body: checkins.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('Pas encore de check-in'),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final checkin = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checkin.date.toString().split(' ')[0],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem('Mood', checkin.mood),
                          _StatItem('Stress', checkin.stress),
                          _StatItem('Energy', checkin.energy),
                        ],
                      ),
                      if (checkin.note.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(checkin.note),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCheckIn(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateCheckIn(BuildContext context, WidgetRef ref) {
    int mood = 5, stress = 5, energy = 5;
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Nouveau check-in'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SliderItem(
                  label: 'Mood: $mood',
                  value: mood.toDouble(),
                  onChanged: (v) => setState(() => mood = v.toInt()),
                ),
                _SliderItem(
                  label: 'Stress: $stress',
                  value: stress.toDouble(),
                  onChanged: (v) => setState(() => stress = v.toInt()),
                ),
                _SliderItem(
                  label: 'Energy: $energy',
                  value: energy.toDouble(),
                  onChanged: (v) => setState(() => energy = v.toInt()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    hintText: 'Note (optionnel)',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(createCheckInProvider({
                    'date': DateTime.now(),
                    'mood': mood,
                    'stress': stress,
                    'energy': energy,
                    'note': noteController.text,
                  }).future);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ref.refresh(checkinsProvider);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
              child: const Text('Sauver'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen Letters
class LettersScreen extends ConsumerWidget {
  const LettersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final letters = ref.watch(lettersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lettres mensuelles')),
      body: letters.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text('Pas encore de lettres'),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final letter = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        letter.month,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        letter.content.length > 100
                            ? '${letter.content.substring(0, 100)}...'
                            : letter.content,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Erreur: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateLetter(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateLetter(BuildContext context, WidgetRef ref) {
    final contentController = TextEditingController();
    final now = DateTime.now();
    final month = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle lettre'),
        content: TextField(
          controller: contentController,
          decoration: const InputDecoration(
            hintText: 'Vos pensées...',
          ),
          maxLines: 8,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(saveLetterProvider({
                  'month': month,
                  'content': contentController.text,
                }).future);
                if (context.mounted) {
                  Navigator.pop(context);
                  ref.refresh(lettersProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: const Text('Sauver'),
          ),
        ],
      ),
    );
  }
}

/// Widget helper pour afficher un stat
class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          '$value/10',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// Widget helper pour les sliders
class _SliderItem extends StatelessWidget {
  final String label;
  final double value;
  final Function(double) onChanged;

  const _SliderItem({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 1,
          max: 10,
          divisions: 9,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
