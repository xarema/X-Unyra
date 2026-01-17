import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import '../../providers.dart';

class SmartPollingService {
  final ApiService apiService;
  Timer? _pollTimer;
  bool _isPolling = false;

  SmartPollingService(this.apiService);

  /// Démarre le polling automatique toutes les 3 secondes
  Future<void> startPolling(String since) async {
    if (_isPolling) return;

    _isPolling = true;
    _pollTimer?.cancel();

    // Première vérification immédiate
    await _pollOnce(since);

    // Puis polling périodique
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _pollOnce(since);
    });
  }

  /// Arrête le polling
  void stopPolling() {
    _isPolling = false;
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Effectue une seule requête de polling
  Future<Map<String, dynamic>> _pollOnce(String since) async {
    try {
      final changes = await apiService.getChanges(since: since);
      return changes;
    } catch (e) {
      print('Polling error: $e');
      return {};
    }
  }

  /// Vérifie s'il y a des changements pour un type de ressource
  bool hasChanges(Map<String, dynamic> response, String resourceType) {
    return (response[resourceType] as List?)?.isNotEmpty ?? false;
  }

  /// Récupère les changements pour un type spécifique
  List<dynamic> getChangesForType(Map<String, dynamic> response, String resourceType) {
    return (response[resourceType] as List?) ?? [];
  }

  /// Dispose le service
  void dispose() {
    stopPolling();
  }
}

/// Provider pour le service de polling
final smartPollingServiceProvider = Provider<SmartPollingService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SmartPollingService(apiService);
});

/// Provider pour tracker la dernière synchronisation
final lastSyncTimeProvider = StateProvider<DateTime>((ref) {
  return DateTime.now().subtract(const Duration(hours: 24));
});

/// Provider pour les changements détectés
final changesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final pollingService = ref.watch(smartPollingServiceProvider);
  final lastSync = ref.watch(lastSyncTimeProvider);

  try {
    final changes = await pollingService._pollOnce(
      lastSync.toIso8601String(),
    );

    // Mettre à jour le temps de sync
    ref.read(lastSyncTimeProvider.notifier).state = DateTime.now();

    return changes;
  } catch (e) {
    return {};
  }
});
