import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/question.dart';
import '../../repos/qna_repo.dart';

final qnaListProvider = FutureProvider.autoDispose<List<Question>>((ref) async {
  final repo = ref.read(qnaRepoProvider);
  return repo.listQuestions();
});
