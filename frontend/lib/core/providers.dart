import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../repos/repositories.dart';

// ============================================================================
// API Client Provider
// ============================================================================

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// ============================================================================
// Repository Providers
// ============================================================================

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepository(apiClient);
});

final coupleRepositoryProvider = Provider<CoupleRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CoupleRepository(apiClient);
});

// ============================================================================
// Auth State Providers
// ============================================================================

/// État de l'utilisateur actuel
final currentUserProvider = FutureProvider<User?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  try {
    return await authRepo.getCurrentUser();
  } catch (e) {
    return null;
  }
});

/// État indiquant si l'utilisateur est authentifié
final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  return user != null;
});

// ============================================================================
// Couple State Providers
// ============================================================================

/// État du couple actuel
final currentCoupleProvider = FutureProvider<Couple?>((ref) async {
  final coupleRepo = ref.watch(coupleRepositoryProvider);
  try {
    return await coupleRepo.getCouple();
  } catch (e) {
    return null;
  }
});

/// Notifier pour gérer les opérations d'authentification
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepo;

  AuthNotifier(this._authRepo) : super(const AsyncValue.data(null));

  /// S'inscrire
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepo.register(
      username: username,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
      firstName: firstName,
      lastName: lastName,
    ).then((response) => response.user));
  }

  /// Se connecter
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authRepo.login(
      email: email,
      password: password,
    ).then((response) => response.user));
  }

  /// Se déconnecter
  Future<void> logout() async {
    await _authRepo.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepo);
});

/// Notifier pour gérer les opérations sur le couple
class CoupleNotifier extends StateNotifier<AsyncValue<Couple?>> {
  final CoupleRepository _coupleRepo;

  CoupleNotifier(this._coupleRepo) : super(const AsyncValue.data(null));

  /// Créer un couple
  Future<void> createCouple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _coupleRepo.createCouple());
  }

  /// Obtenir le couple actuel
  Future<void> fetchCouple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _coupleRepo.getCouple());
  }

  /// Rejoindre un couple
  Future<void> joinCouple(String code) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _coupleRepo.joinCouple(code: code));
  }
}

final coupleNotifierProvider =
    StateNotifierProvider<CoupleNotifier, AsyncValue<Couple?>>((ref) {
  final coupleRepo = ref.watch(coupleRepositoryProvider);
  return CoupleNotifier(coupleRepo);
});

/// Provider pour générer un code d'invitation
final inviteCodeProvider = FutureProvider.family<PairingInvite, int>((
  ref,
  ttlMinutes,
) async {
  final coupleRepo = ref.watch(coupleRepositoryProvider);
  return coupleRepo.generateInviteCode(ttlMinutes: ttlMinutes);
});
