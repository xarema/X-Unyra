import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _baseUrl = 'http://127.0.0.1:8000/api';

/// Client API centralisé pour communiquer avec le backend Django
class ApiClient {
  final Dio _dio;
  final _secureStorage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  /// Initialiser le client avec les tokens stockés
  Future<void> init() async {
    _accessToken = await _secureStorage.read(key: 'access_token');
    _refreshToken = await _secureStorage.read(key: 'refresh_token');
  }

  /// Intercepteur pour ajouter le token à chaque requête
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_accessToken != null) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }
    handler.next(options);
  }

  /// Intercepteur pour gérer les erreurs (notamment token expiré)
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token expiré, essayer de le rafraîchir
      if (_refreshToken != null) {
        try {
          final response = await _refreshAccessToken();
          _accessToken = response['access'];
          await _secureStorage.write(key: 'access_token', value: _accessToken!);

          // Réessayer la requête originale avec le nouveau token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $_accessToken';
          handler.resolve(await _dio.request(
            options.path,
            options: Options(
              method: options.method,
              headers: options.headers,
              responseType: options.responseType,
              contentType: options.contentType,
              validateStatus: options.validateStatus,
            ),
          ));
          return;
        } catch (e) {
          // Rafraîchissement échoué, l'utilisateur doit se reconnecter
          // Le notifier global gérera la redirection vers login
          clearTokens();
        }
      }
    }
    handler.next(err);
  }

  /// Rafraîchir le token d'accès
  Future<Map<String, dynamic>> _refreshAccessToken() async {
    final response = await _dio.post(
      '/auth/refresh/',
      data: {'refresh': _refreshToken},
    );
    return response.data;
  }

  /// Sauvegarder les tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  /// Effacer les tokens
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  /// GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  /// POST request
  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  /// PATCH request
  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  /// DELETE request
  Future<Response> delete(String path) {
    return _dio.delete(path);
  }
}
