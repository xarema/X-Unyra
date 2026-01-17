import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';

class AuthState {
  final bool initialized;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    required this.initialized,
    required this.accessToken,
    required this.refreshToken,
  });

  bool get isAuthenticated => (accessToken != null && accessToken!.isNotEmpty);

  AuthState copyWith({
    bool? initialized,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      initialized: initialized ?? this.initialized,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  static const empty = AuthState(initialized: false, accessToken: null, refreshToken: null);
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(const FlutterSecureStorage());
});

class AuthNotifier extends StateNotifier<AuthState> {
  static const _kAccess = 'accessToken';
  static const _kRefresh = 'refreshToken';

  final FlutterSecureStorage _storage;
  final Dio _dio;

  AuthNotifier(this._storage)
      : _dio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl)),
        super(AuthState.empty) {
    _init();
  }

  Future<void> _init() async {
    final access = await _storage.read(key: _kAccess);
    final refresh = await _storage.read(key: _kRefresh);
    state = AuthState(initialized: true, accessToken: access, refreshToken: refresh);
  }

  Future<void> logout() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    state = state.copyWith(accessToken: null, refreshToken: null);
  }

  Future<void> login({required String username, required String password}) async {
    final res = await _dio.post('/auth/login/', data: {
      'username': username,
      'password': password,
    });
    final access = res.data['access'] as String;
    final refresh = res.data['refresh'] as String;
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
    state = state.copyWith(accessToken: access, refreshToken: refresh);
  }

  Future<void> register({
    required String username,
    required String password,
    String? email,
    String language = 'fr',
    String timezone = 'UTC',
  }) async {
    final res = await _dio.post('/auth/register/', data: {
      'username': username,
      'password': password,
      'password_confirm': password,
      'email': email,
      'language': language,
      'timezone': timezone,
    });

    final access = res.data['access'] as String;
    final refresh = res.data['refresh'] as String;
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
    state = state.copyWith(accessToken: access, refreshToken: refresh);
  }
}
