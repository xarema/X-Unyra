import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/checkins_models.dart';
import '../../../providers.dart';

class CheckInsScreen extends ConsumerStatefulWidget {
  const CheckInsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckInsScreen> createState() => _CheckInsScreenState();
}

class _CheckInsScreenState extends ConsumerState<CheckInsScreen> {
  late int _mood;
  late int _stress;
  late int _energy;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mood = 5;
    _stress = 5;
    _energy = 5;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitCheckIn() {
    // TODO: Envoyer le check-in via l'API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Check-in enregistré!')),
    );
    _noteController.clear();
    setState(() {
      _mood = 5;
      _stress = 5;
      _energy = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comment allez-vous aujourd\'hui?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _SliderSection(
              title: 'Humeur',
              value: _mood,
              onChanged: (value) => setState(() => _mood = value),
              emoji: _getEmojiForMood(_mood),
            ),
            const SizedBox(height: 24),
            _SliderSection(
              title: 'Stress',
              value: _stress,
              onChanged: (value) => setState(() => _stress = value),
              emoji: _getEmojiForStress(_stress),
            ),
            const SizedBox(height: 24),
            _SliderSection(
              title: 'Énergie',
              value: _energy,
              onChanged: (value) => setState(() => _energy = value),
              emoji: _getEmojiForEnergy(_energy),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optionnel)',
                border: OutlineInputBorder(),
                hintText: 'Écrivez ce qui vous passe par la tête...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitCheckIn,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Enregistrer le check-in'),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 32),
            const Text(
              'Historique (7 derniers jours)',
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

  String _getEmojiForMood(int value) {
    if (value <= 3) return '😢';
    if (value <= 5) return '😐';
    if (value <= 7) return '😊';
    return '😄';
  }

  String _getEmojiForStress(int value) {
    if (value <= 3) return '😌';
    if (value <= 5) return '😐';
    if (value <= 7) return '😰';
    return '😱';
  }

  String _getEmojiForEnergy(int value) {
    if (value <= 3) return '😴';
    if (value <= 5) return '😐';
    if (value <= 7) return '⚡';
    return '🚀';
  }
}

class _SliderSection extends StatelessWidget {
  final String title;
  final int value;
  final ValueChanged<int> onChanged;
  final String emoji;

  const _SliderSection({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Text(
                  '$value/10',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: value.toString(),
          onChanged: (newValue) => onChanged(newValue.toInt()),
        ),
      ],
    );
  }
}

/// Widget pour afficher l'historique des check-ins
class CheckInHistory extends StatelessWidget {
  final List<CheckIn> checkIns;

  const CheckInHistory({
    Key? key,
    required this.checkIns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (checkIns.isEmpty) {
      return const Center(
        child: Text('Pas de check-ins enregistrés'),
      );
    }

    return ListView.builder(
      itemCount: checkIns.length,
      itemBuilder: (context, index) {
        final checkIn = checkIns[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, dd MMM yyyy', 'fr_FR').format(checkIn.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _CheckInStat(
                      label: 'Humeur',
                      value: checkIn.mood,
                      emoji: _getEmoji('mood', checkIn.mood),
                    ),
                    _CheckInStat(
                      label: 'Stress',
                      value: checkIn.stress,
                      emoji: _getEmoji('stress', checkIn.stress),
                    ),
                    _CheckInStat(
                      label: 'Énergie',
                      value: checkIn.energy,
                      emoji: _getEmoji('energy', checkIn.energy),
                    ),
                  ],
                ),
                if (checkIn.note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    checkIn.note,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getEmoji(String type, int value) {
    if (type == 'mood') {
      if (value <= 3) return '😢';
      if (value <= 5) return '😐';
      if (value <= 7) return '😊';
      return '😄';
    } else if (type == 'stress') {
      if (value <= 3) return '😌';
      if (value <= 5) return '😐';
      if (value <= 7) return '😰';
      return '😱';
    } else {
      if (value <= 3) return '😴';
      if (value <= 5) return '😐';
      if (value <= 7) return '⚡';
      return '🚀';
    }
  }
}

class _CheckInStat extends StatelessWidget {
  final String label;
  final int value;
  final String emoji;

  const _CheckInStat({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('$value/10'),
      ],
    );
  }
}
