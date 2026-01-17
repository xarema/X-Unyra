import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/question.dart';

final qnaRepoProvider = Provider<QnaRepo>((ref) {
  return QnaRepo(ref.read(dioProvider));
});

class QnaRepo {
  final Dio _dio;
  QnaRepo(this._dio);

  Future<List<Question>> listQuestions() async {
    final res = await _dio.get('/qna/questions/');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Question.fromJson).toList();
  }

  Future<void> answerQuestion({required String questionId, required String status, required String text}) async {
    await _dio.post('/qna/questions/$questionId/answer/', data: {
      'status': status,
      'text': text,
    });
  }

  Future<Question> getQuestion(String id) async {
    final res = await _dio.get('/qna/questions/$id/');
    return Question.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> createQuestion({required String text, String theme = ''}) async {
    await _dio.post('/qna/questions/', data: {'text': text, 'theme': theme});
  }
}
