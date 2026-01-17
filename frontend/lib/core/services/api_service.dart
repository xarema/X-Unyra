import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config.dart';
import 'token_storage.dart';

class ApiService {
  late final Dio _dio;


  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Ajouter l'intercepteur pour les tokens
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ajouter le token si présent
          final token = await TokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            debugPrint('🔐 Token added to request');
          }
          debugPrint('📤 ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('📥 ${response.statusCode} ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Essayer de rafraîchir le token
            final refreshed = await refreshAccessToken();
            if (refreshed) {
              return handler.resolve(await _retry(error.requestOptions));
            } else {
              // Déconnecter l'utilisateur
              await logout();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ==================== AUTH ====================

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirm,
    String? firstName,
    String? lastName,
    String language = 'fr',
    String timezone = 'UTC',
  }) async {
    final response = await _dio.post(
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

    await _saveTokens(
      response.data['access'],
      response.data['refresh'],
    );

    return response.data;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    debugPrint('🔐 Login attempt for: $email');

    try {
      final response = await _dio.post(
        '/auth/login/',
        data: {
          'email': email,
          'password': password,
        },
      );

      debugPrint('✅ Login response received: ${response.statusCode}');
      debugPrint('📦 Response data: ${response.data}');

      await _saveTokens(
        response.data['access'],
        response.data['refresh'],
      );

      debugPrint('✅ Tokens saved successfully');
      return response.data;
    } catch (e) {
      debugPrint('❌ Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get('/auth/me/');
    return response.data;
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
  }

  // ==================== COUPLE ====================

  Future<Map<String, dynamic>> createCouple() async {
    final response = await _dio.post('/couple/create/');
    return response.data;
  }

  Future<Map<String, dynamic>> getCouple() async {
    final response = await _dio.get('/couple/');
    return response.data;
  }

  Future<Map<String, dynamic>> generateInviteCode({
    int ttlMinutes = 60,
  }) async {
    final response = await _dio.post(
      '/couple/invite/',
      data: {'ttl_minutes': ttlMinutes},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> joinCouple({
    required String code,
  }) async {
    final response = await _dio.post(
      '/couple/join/',
      data: {'code': code},
    );
    return response.data;
  }

  // ==================== SYNC ====================

  Future<Map<String, dynamic>> getChanges({
    required String since,
  }) async {
    final response = await _dio.get(
      '/sync/changes/',
      queryParameters: {'since': since},
    );
    return response.data;
  }

  // ==================== Q&A ====================

  Future<Map<String, dynamic>> createQuestion({
    required String text,
    String theme = '',
  }) async {
    final response = await _dio.post(
      '/questions/',
      data: {
        'text': text,
        'theme': theme,
      },
    );
    return response.data;
  }

  Future<List<dynamic>> getQuestions() async {
    final response = await _dio.get('/questions/');
    return response.data['results'] ?? [];
  }

  Future<Map<String, dynamic>> answerQuestion({
    required int questionId,
    required String status,
    String text = '',
  }) async {
    final response = await _dio.post(
      '/answers/',
      data: {
        'question': questionId,
        'status': status,
        'text': text,
      },
    );
    return response.data;
  }

  // ==================== TOKEN MANAGEMENT ====================

  Future<String?> getAccessToken() async {
    return await TokenStorage.getAccessToken();
  }

  Future<String?> getRefreshToken() async {
    return await TokenStorage.getRefreshToken();
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await TokenStorage.saveTokens(accessToken, refreshToken);
  }

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await _dio.post(
        '/auth/refresh/',
        data: {'refresh': refreshToken},
      );

      await TokenStorage.saveTokens(
        response.data['access'],
        refreshToken,
      );

      return true;
    } catch (e) {
      debugPrint('❌ Token refresh failed: $e');
      return false;
    }
  }

  bool isAuthenticated() {
    return _dio.options.headers['Authorization'] != null;
  }
}
