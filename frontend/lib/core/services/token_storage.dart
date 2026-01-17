import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

/// Token storage that works on both mobile and web
class TokenStorage {
  static const String _accessTokenKey = 'couple_app_access_token';
  static const String _refreshTokenKey = 'couple_app_refresh_token';

  // In-memory cache for all platforms
  static final Map<String, String> _memoryCache = {};

  /// Save tokens (web uses localStorage, mobile uses in-memory)
  static Future<void> saveTokens(String accessToken, String refreshToken) async {
    debugPrint('💾 Saving tokens...');
    debugPrint('   Access token length: ${accessToken.length}');
    debugPrint('   Refresh token length: ${refreshToken.length}');

    if (kIsWeb) {
      try {
        // Web: use localStorage
        web.window.localStorage[_accessTokenKey] = accessToken;
        web.window.localStorage[_refreshTokenKey] = refreshToken;
        debugPrint('✅ Tokens saved to localStorage');

        // Verify
        final saved = web.window.localStorage[_accessTokenKey];
        debugPrint('✅ Verification: token exists = ${saved != null && saved.isNotEmpty}');
      } catch (e) {
        debugPrint('⚠️  localStorage save failed: $e, using memory fallback');
        _memoryCache[_accessTokenKey] = accessToken;
        _memoryCache[_refreshTokenKey] = refreshToken;
      }
    } else {
      // Mobile: use in-memory
      _memoryCache[_accessTokenKey] = accessToken;
      _memoryCache[_refreshTokenKey] = refreshToken;
      debugPrint('✅ Tokens saved to memory');
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    if (kIsWeb) {
      try {
        return web.window.localStorage[_accessTokenKey];
      } catch (e) {
        return _memoryCache[_accessTokenKey];
      }
    }
    return _memoryCache[_accessTokenKey];
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    if (kIsWeb) {
      try {
        return web.window.localStorage[_refreshTokenKey];
      } catch (e) {
        return _memoryCache[_refreshTokenKey];
      }
    }
    return _memoryCache[_refreshTokenKey];
  }

  /// Clear tokens (logout)
  static Future<void> clearTokens() async {
    if (kIsWeb) {
      try {
        web.window.localStorage.removeItem(_accessTokenKey);
        web.window.localStorage.removeItem(_refreshTokenKey);
        debugPrint('✅ Tokens cleared from localStorage');
      } catch (e) {
        debugPrint('⚠️  localStorage clear failed: $e');
      }
    }
    _memoryCache.clear();
  }

  /// Check if tokens exist
  static Future<bool> hasTokens() async {
    final access = await getAccessToken();
    return access != null && access.isNotEmpty;
  }
}
