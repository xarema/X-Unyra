import 'dart:async';
import 'package:flutter/foundation.dart';
import '../repos/feature_repositories.dart';

/// Manager pour le smart polling
class PollingManager extends ChangeNotifier {
  final SyncRepository _syncRepo;

  Timer? _pollingTimer;
  DateTime _lastSync = DateTime.now().subtract(Duration(hours: 1));

  int _activeCount = 0; // Nombre d'écrans actifs

  // Intervals
  static const Duration _activeInterval = Duration(seconds: 5);
  static const Duration _backgroundInterval = Duration(seconds: 30);

  bool get isPolling => _pollingTimer != null;
  bool get isActive => _activeCount > 0;

  PollingManager(this._syncRepo);

  /// Démarrer le polling quand l'app devient active
  void appBecameActive() {
    _activeCount++;
    _startPolling();
  }

  /// Arrêter le polling quand l'app devient inactive
  void appBecameInactive() {
    _activeCount = (_activeCount - 1).clamp(0, double.infinity).toInt();
    if (_activeCount == 0) {
      _stopPolling();
    }
  }

  /// Démarrer le polling
  void _startPolling() {
    if (isPolling) return;

    _pollingTimer = Timer.periodic(
      isActive ? _activeInterval : _backgroundInterval,
      (_) => _poll(),
    );

    // Poll immédiatement
    _poll();
  }

  /// Arrêter le polling
  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Effectuer un poll
  Future<void> _poll() async {
    try {
      final changes = await _syncRepo.getChanges(since: _lastSync);
      _lastSync = changes.serverTime;

      // Notifier les listeners des changements
      notifyListeners();

      // TODO: Dispatch changes to relevant providers
    } catch (e) {
      if (kDebugMode) {
        print('Polling error: $e');
      }
    }

    // Ajuster la fréquence selon l'état
    if (isPolling) {
      final newInterval =
          isActive ? _activeInterval : _backgroundInterval;
      if (_pollingTimer?.isActive ?? false) {
        _pollingTimer?.cancel();
      }
      _pollingTimer = Timer.periodic(newInterval, (_) => _poll());
    }
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }
}
