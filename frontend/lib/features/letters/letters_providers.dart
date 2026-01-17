import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/letter.dart';
import '../../repos/letters_repo.dart';

String currentMonth() {
  final now = DateTime.now();
  return '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}';
}

final currentLetterProvider = FutureProvider.autoDispose<Letter?>((ref) async {
  final repo = ref.read(lettersRepoProvider);
  return repo.getByMonth(currentMonth());
});
