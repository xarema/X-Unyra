import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/qna_models.dart';
import '../../../providers.dart';

class QnaScreen extends ConsumerStatefulWidget {
  const QnaScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<QnaScreen> createState() => _QnaScreenState();
}

class _QnaScreenState extends ConsumerState<QnaScreen> {
  final _questionTextController = TextEditingController();
  final _answerTextController = TextEditingController();
  int? _expandedQuestionId;
  String? _selectedAnswerStatus = 'ANSWERED';

  @override
  void dispose() {
    _questionTextController.dispose();
    _answerTextController.dispose();
    super.dispose();
  }

  void _showCreateQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle question'),
        content: TextField(
          controller: _questionTextController,
          decoration: const InputDecoration(
            labelText: 'Votre question',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (_questionTextController.text.isNotEmpty) {
                // Créer la question via l'API
                ref
                    .read(apiServiceProvider)
                    .createQuestion(text: _questionTextController.text);
                _questionTextController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question créée!')),
                );
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showAnswerDialog(int questionId) {
    _selectedAnswerStatus = 'ANSWERED';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Répondre à la question'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: _selectedAnswerStatus,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedAnswerStatus = value);
                }
              },
              items: const [
                DropdownMenuItem(value: 'ANSWERED', child: Text('Répondu')),
                DropdownMenuItem(value: 'NEEDS_TIME', child: Text('J\'ai besoin de temps')),
                DropdownMenuItem(value: 'CLARIFY', child: Text('À clarifier')),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _answerTextController,
              decoration: const InputDecoration(
                labelText: 'Votre réponse (optionnel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(apiServiceProvider).answerQuestion(
                questionId: questionId,
                status: _selectedAnswerStatus ?? 'ANSWERED',
                text: _answerTextController.text,
              );
              _answerTextController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Réponse enregistrée!')),
              );
            },
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer les questions via l'API
    // TODO: Implémenter avec FutureProvider une fois que le modèle est prêt

    return Scaffold(
      appBar: AppBar(title: const Text('Questions & Réponses')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Q&A Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('À implémenter avec les providers'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateQuestionDialog,
        tooltip: 'Nouvelle question',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget pour afficher une seule question avec ses réponses
class QuestionTile extends ConsumerWidget {
  final Question question;
  final VoidCallback onAnswer;

  const QuestionTile({
    Key? key,
    required this.question,
    required this.onAnswer,
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
            Text(
              question.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Question de ${question.createdBy}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            if (question.answers.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Réponses:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              for (var answer in question.answers) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(answer.status),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${answer.user} - ${_getStatusLabel(answer.status)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (answer.text.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(answer.text),
                      ],
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAnswer,
              child: const Text('Répondre'),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ANSWERED':
        return Colors.green[50]!;
      case 'NEEDS_TIME':
        return Colors.orange[50]!;
      case 'CLARIFY':
        return Colors.blue[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'ANSWERED':
        return 'Répondu';
      case 'NEEDS_TIME':
        return 'J\'ai besoin de temps';
      case 'CLARIFY':
        return 'À clarifier';
      default:
        return status;
    }
  }
}
