import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/models.dart';

/// Repository pour l'authentification
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  /// S'inscrire
  Future<AuthResponse> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
    String language = 'fr',
    String timezone = 'UTC',
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/register/',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'password_confirm': passwordConfirm,
          'first_name': firstName ?? '',
          'last_name': lastName ?? '',
          'language': language,
          'timezone': timezone,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Sauvegarder les tokens
      await _apiClient.saveTokens(
        accessToken: authResponse.access,
        refreshToken: authResponse.refresh,
      );

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Se connecter
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response.data);

      // Sauvegarder les tokens
      await _apiClient.saveTokens(
        accessToken: authResponse.access,
        refreshToken: authResponse.refresh,
      );

      return authResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtenir l'utilisateur actuel
  Future<User> getCurrentUser() async {
    try {
      final response = await _apiClient.get('/auth/me/');
      return User.fromJson(response.data['user']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Se déconnecter (supprimer les tokens)
  Future<void> logout() async {
    await _apiClient.clearTokens();
  }

  /// Gérer les erreurs
  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final errors = e.response!.data as Map<String, dynamic>;
      // Retourner le premier message d'erreur
      if (errors.containsKey('detail')) {
        return errors['detail'] as String;
      }
      final firstError = errors.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
    }
    return e.message ?? 'Une erreur est survenue';
  }
}

/// Repository pour le couple
class CoupleRepository {
  final ApiClient _apiClient;

  CoupleRepository(this._apiClient);

  /// Créer un couple
  Future<Couple> createCouple() async {
    try {
      final response = await _apiClient.post('/couple/create/');
      return Couple.fromJson(response.data['couple']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Obtenir le couple actuel
  Future<Couple> getCouple() async {
    try {
      final response = await _apiClient.get('/couple/');
      return Couple.fromJson(response.data['couple']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Générer un code d'invitation
  Future<PairingInvite> generateInviteCode({int ttlMinutes = 60}) async {
    try {
      final response = await _apiClient.post(
        '/couple/invite/',
        data: {'ttl_minutes': ttlMinutes},
      );
      return PairingInvite.fromJson(response.data['invite']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Rejoindre un couple avec un code
  Future<Couple> joinCouple({required String code}) async {
    try {
      final response = await _apiClient.post(
        '/couple/join/',
        data: {'code': code},
      );
      return Couple.fromJson(response.data['couple']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gérer les erreurs
  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Une erreur est survenue';
  }
}
