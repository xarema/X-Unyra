import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/goal.dart';
import '../../repos/goals_repo.dart';

final goalsListProvider = FutureProvider.autoDispose<List<Goal>>((ref) async {
  final repo = ref.read(goalsRepoProvider);
  return repo.listGoals();
});
