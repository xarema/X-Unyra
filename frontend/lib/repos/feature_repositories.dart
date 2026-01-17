import 'package:dio/dio.dart';
import '../core/api_client.dart';
import '../models/feature_models.dart';

/// Repository pour les Q&A
class QnaRepository {
  final ApiClient _apiClient;

  QnaRepository(this._apiClient);

  /// Lister les questions
  Future<List<Question>> listQuestions() async {
    try {
      final response = await _apiClient.get('/qna/questions/');
      final results = response.data['results'] as List;
      return results.map((q) => Question.fromJson(q)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer une question
  Future<Question> createQuestion({
    required String text,
    String theme = '',
  }) async {
    try {
      final response = await _apiClient.post(
        '/qna/questions/',
        data: {'text': text, 'theme': theme},
      );
      return Question.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Répondre à une question
  Future<Answer> answerQuestion({
    required String questionId,
    required String status,
    String text = '',
  }) async {
    try {
      final response = await _apiClient.post(
        '/qna/questions/$questionId/answer/',
        data: {'status': status, 'text': text},
      );
      return Answer.fromJson(response.data['answer']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Erreur Q&A';
  }
}

/// Repository pour les Goals
class GoalsRepository {
  final ApiClient _apiClient;

  GoalsRepository(this._apiClient);

  /// Lister les goals
  Future<List<Goal>> listGoals() async {
    try {
      final response = await _apiClient.get('/goals/');
      final results = response.data['results'] as List;
      return results.map((g) => Goal.fromJson(g)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer un goal
  Future<Goal> createGoal({
    required String title,
    String whyForUs = '',
    String status = 'ACTIVE',
  }) async {
    try {
      final response = await _apiClient.post(
        '/goals/',
        data: {
          'title': title,
          'why_for_us': whyForUs,
          'status': status,
        },
      );
      return Goal.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Mettre à jour un goal
  Future<Goal> updateGoal({
    required String id,
    required String status,
  }) async {
    try {
      final response = await _apiClient.patch(
        '/goals/$id/',
        data: {'status': status},
      );
      return Goal.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Erreur Goals';
  }
}

/// Repository pour les Check-ins
class CheckInsRepository {
  final ApiClient _apiClient;

  CheckInsRepository(this._apiClient);

  /// Lister les check-ins
  Future<List<CheckIn>> listCheckIns() async {
    try {
      final response = await _apiClient.get('/checkins/');
      final results = response.data['results'] as List;
      return results.map((c) => CheckIn.fromJson(c)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer un check-in
  Future<CheckIn> createCheckIn({
    required DateTime date,
    required int mood,
    required int stress,
    required int energy,
    String note = '',
  }) async {
    try {
      final response = await _apiClient.post(
        '/checkins/',
        data: {
          'date': date.toIso8601String().split('T')[0],
          'mood': mood,
          'stress': stress,
          'energy': energy,
          'note': note,
        },
      );
      return CheckIn.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Erreur Check-in';
  }
}

/// Repository pour les Letters
class LettersRepository {
  final ApiClient _apiClient;

  LettersRepository(this._apiClient);

  /// Lister les letters
  Future<List<Letter>> listLetters() async {
    try {
      final response = await _apiClient.get('/letters/');
      final results = response.data['results'] as List;
      return results.map((l) => Letter.fromJson(l)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Créer/mettre à jour une letter
  Future<Letter> saveOrUpdateLetter({
    required String month,
    required String content,
  }) async {
    try {
      final response = await _apiClient.post(
        '/letters/',
        data: {
          'month': month,
          'content': content,
        },
      );
      return Letter.fromJson(response.data['letter'] ?? response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Erreur Letter';
  }
}

/// Repository pour la synchronisation
class SyncRepository {
  final ApiClient _apiClient;

  SyncRepository(this._apiClient);

  /// Récupérer les changements depuis un timestamp
  Future<SyncChanges> getChanges({DateTime? since}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }

      final response = await _apiClient.get(
        '/sync/changes/',
        queryParameters: queryParams,
      );

      return SyncChanges.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data is Map) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'] as String;
      }
    }
    return e.message ?? 'Erreur Sync';
  }
}
