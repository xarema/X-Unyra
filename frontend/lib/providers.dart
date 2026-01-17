import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/api_service.dart';

// ==================== API SERVICE PROVIDER ====================
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// ==================== AUTH STATE ====================

class AuthState {
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService apiService;

  AuthNotifier(this.apiService) : super(const AuthState());

  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.login(
        email: email,
        password: password,
      );

      state = state.copyWith(
        isAuthenticated: true,
        user: response['user'],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Login failed: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final response = await apiService.register(
        username: username,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
        firstName: firstName,
        lastName: lastName,
      );

      state = state.copyWith(
        isAuthenticated: true,
        user: response['user'],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Registration failed: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await apiService.logout();
    state = const AuthState();
  }

  Future<void> checkAuth() async {
    try {
      final token = await apiService.getAccessToken();
      if (token != null) {
        final response = await apiService.getMe();
        state = state.copyWith(
          isAuthenticated: true,
          user: response['user'],
        );
      }
    } catch (e) {
      state = const AuthState();
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});

// Provider pour initialiser l'authentification au démarrage
final authInitializationProvider = FutureProvider<void>((ref) async {
  final authNotifier = ref.read(authProvider.notifier);
  await authNotifier.checkAuth();
});

// ==================== COUPLE STATE ====================

class CoupleState {
  final Map<String, dynamic>? couple;
  final String? error;
  final bool isLoading;

  const CoupleState({
    this.couple,
    this.error,
    this.isLoading = false,
  });

  CoupleState copyWith({
    Map<String, dynamic>? couple,
    String? error,
    bool? isLoading,
  }) {
    return CoupleState(
      couple: couple ?? this.couple,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CoupleNotifier extends StateNotifier<CoupleState> {
  final ApiService apiService;

  CoupleNotifier(this.apiService) : super(const CoupleState());

  Future<bool> createCouple() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await apiService.createCouple();
      state = state.copyWith(
        couple: response['couple'],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create couple: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> getCouple() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await apiService.getCouple();
      state = state.copyWith(
        couple: response['couple'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load couple: $e',
        isLoading: false,
      );
    }
  }

  Future<bool> joinCouple(String code) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await apiService.joinCouple(code: code);
      state = state.copyWith(
        couple: response['couple'],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to join couple: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<String?> generateInviteCode() async {
    try {
      final response = await apiService.generateInviteCode();
      return response['invite']['code'];
    } catch (e) {
      state = state.copyWith(error: 'Failed to generate code: $e');
      return null;
    }
  }
}

final coupleProvider = StateNotifierProvider<CoupleNotifier, CoupleState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CoupleNotifier(apiService);
});
