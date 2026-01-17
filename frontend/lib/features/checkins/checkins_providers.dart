import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/checkin.dart';
import '../../repos/checkins_repo.dart';

final checkinsProvider = FutureProvider.autoDispose<List<CheckIn>>((ref) async {
  final repo = ref.read(checkinsRepoProvider);
  return repo.listRecent();
});
