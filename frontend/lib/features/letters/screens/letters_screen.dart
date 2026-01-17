import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/letters_models.dart';
import '../../../providers.dart';

class LettersScreen extends ConsumerStatefulWidget {
  const LettersScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends ConsumerState<LettersScreen> {
  final _contentController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _saveLetter() {
    // TODO: Envoyer la lettre via l'API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lettre sauvegardée!')),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final monthName = DateFormat('MMMM yyyy', 'fr_FR').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lettres Mensuelles'),
        actions: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: TextButton(
                  onPressed: _saveLetter,
                  child: const Text(
                    'Enregistrer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lettre de $monthName',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Partagez vos pensées et sentiments du mois',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            if (!_isEditing)
              ElevatedButton(
                onPressed: () => setState(() => _isEditing = true),
                child: const Text('Modifier la lettre'),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 16),
            if (_isEditing)
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Votre lettre',
                  border: OutlineInputBorder(),
                  hintText: 'Écrivez votre réflexion mensuelle...',
                ),
                maxLines: 12,
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _contentController.text.isEmpty
                      ? 'Pas encore de lettre pour ce mois'
                      : _contentController.text,
                  style: TextStyle(
                    color: _contentController.text.isEmpty
                        ? Colors.grey[400]
                        : Colors.black,
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            const Text(
              'Lettres précédentes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('À implémenter avec les providers'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher une lettre passée
class LetterCard extends StatelessWidget {
  final Letter letter;

  const LetterCard({
    Key? key,
    required this.letter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy', 'fr_FR').format(
      DateTime.parse('${letter.month}-01'),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              monthName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              letter.content.length > 150
                  ? '${letter.content.substring(0, 150)}...'
                  : letter.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Afficher la lettre en détail
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(monthName),
                    content: SingleChildScrollView(
                      child: Text(letter.content),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Voir la lettre complète'),
            ),
          ],
        ),
      ),
    );
  }
}
