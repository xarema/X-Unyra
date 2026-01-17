import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/api_client.dart';
import '../models/models.dart';
import '../models/feature_models.dart';
import '../repos/repositories.dart';
import '../repos/feature_repositories.dart';

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

// Feature repositories
final qnaRepositoryProvider = Provider<QnaRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QnaRepository(apiClient);
});

final goalsRepositoryProvider = Provider<GoalsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GoalsRepository(apiClient);
});

final checkinsRepositoryProvider = Provider<CheckInsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CheckInsRepository(apiClient);
});

final lettersRepositoryProvider = Provider<LettersRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LettersRepository(apiClient);
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SyncRepository(apiClient);
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

// ============================================================================
// Feature State Providers
// ============================================================================

/// Lister les questions
final questionsProvider = FutureProvider<List<Question>>((ref) async {
  final qnaRepo = ref.watch(qnaRepositoryProvider);
  return qnaRepo.listQuestions();
});

/// Lister les goals
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  final goalsRepo = ref.watch(goalsRepositoryProvider);
  return goalsRepo.listGoals();
});

/// Lister les check-ins
final checkinsProvider = FutureProvider<List<CheckIn>>((ref) async {
  final checkinsRepo = ref.watch(checkinsRepositoryProvider);
  return checkinsRepo.listCheckIns();
});

/// Lister les letters
final lettersProvider = FutureProvider<List<Letter>>((ref) async {
  final lettersRepo = ref.watch(lettersRepositoryProvider);
  return lettersRepo.listLetters();
});

// ============================================================================
// Auth Notifier
// ============================================================================

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _authRepo;

  AuthNotifier(this._authRepo) : super(const AsyncValue.data(null));

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

// ============================================================================
// Couple Notifier
// ============================================================================

class CoupleNotifier extends StateNotifier<AsyncValue<Couple?>> {
  final CoupleRepository _coupleRepo;

  CoupleNotifier(this._coupleRepo) : super(const AsyncValue.data(null));

  Future<void> createCouple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _coupleRepo.createCouple());
  }

  Future<void> fetchCouple() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _coupleRepo.getCouple());
  }

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

// ============================================================================
// Feature Notifiers
// ============================================================================

/// Notifier pour créer une question
final createQuestionProvider =
    FutureProvider.family<Question, String>((ref, text) async {
  final qnaRepo = ref.watch(qnaRepositoryProvider);
  return qnaRepo.createQuestion(text: text);
});

/// Notifier pour créer un goal
final createGoalProvider =
    FutureProvider.family<Goal, String>((ref, title) async {
  final goalsRepo = ref.watch(goalsRepositoryProvider);
  return goalsRepo.createGoal(title: title);
});

/// Notifier pour créer un check-in
final createCheckInProvider =
    FutureProvider.family<CheckIn, Map<String, dynamic>>((ref, data) async {
  final checkinsRepo = ref.watch(checkinsRepositoryProvider);
  return checkinsRepo.createCheckIn(
    date: data['date'],
    mood: data['mood'],
    stress: data['stress'],
    energy: data['energy'],
    note: data['note'] ?? '',
  );
});

/// Notifier pour sauver une letter
final saveLetterProvider = FutureProvider.family<Letter, Map<String, String>>(
  (ref, data) async {
    final lettersRepo = ref.watch(lettersRepositoryProvider);
    return lettersRepo.saveOrUpdateLetter(
      month: data['month']!,
      content: data['content']!,
    );
  },
);

/// Provider pour générer un code d'invitation
final inviteCodeProvider = FutureProvider.family<PairingInvite, int>((
  ref,
  ttlMinutes,
) async {
  final coupleRepo = ref.watch(coupleRepositoryProvider);
  return coupleRepo.generateInviteCode(ttlMinutes: ttlMinutes);
});
