import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../../features/qna/qna_providers.dart';
import '../../features/goals/goals_providers.dart';
import '../../features/checkins/checkins_providers.dart';
import '../../features/letters/letters_providers.dart';

/// Smart polling (Option A): periodically call /sync/changes and refresh providers.
class PollingManager {
  final Ref ref;
  Timer? _timer;
  DateTime _since = DateTime.now().toUtc().subtract(const Duration(seconds: 5));
  bool _inFlight = false;

  PollingManager(this.ref);

  void start({Duration interval = const Duration(seconds: 5)}) {
    stop();
    _timer = Timer.periodic(interval, (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> tick() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      final dio = ref.read(dioProvider);
      final res = await dio.get('/sync/changes/', queryParameters: {'since': _since.toIso8601String()});
      final serverTime = DateTime.parse(res.data['server_time'].toString()).toUtc();
      final changes = (res.data['changes'] as Map).cast<String, dynamic>();

      bool any(String key) {
        final list = changes[key];
        return list is List && list.isNotEmpty;
      }

      // If something changed in a module, refresh that module's provider(s).
      if (any('qna_questions') || any('qna_answers')) {
        ref.invalidate(qnaListProvider);
      }
      if (any('goals') || any('goal_actions')) {
        ref.invalidate(goalsListProvider);
      }
      if (any('checkins')) {
        ref.invalidate(checkinsProvider);
      }
      if (any('letters')) {
        ref.invalidate(currentLetterProvider);
      }

      _since = serverTime;
    } catch (_) {
      // Swallow errors to keep UI calm; user can manual refresh.
    } finally {
      _inFlight = false;
    }
  }
}
