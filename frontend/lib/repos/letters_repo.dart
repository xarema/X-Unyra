import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/letter.dart';

final lettersRepoProvider = Provider<LettersRepo>((ref) {
  return LettersRepo(ref.read(dioProvider));
});

class LettersRepo {
  final Dio _dio;
  LettersRepo(this._dio);

  Future<Letter?> getByMonth(String month) async {
    final res = await _dio.get('/letters/', queryParameters: {'month': month});
    final list = (res.data as List).cast<Map<String, dynamic>>();
    if (list.isEmpty) return null;
    return Letter.fromJson(list.first);
  }

  Future<Letter> upsert({required String month, required String content}) async {
    final res = await _dio.post('/letters/', data: {'month': month, 'content': content});
    final letter = res.data['letter'] as Map<String, dynamic>;
    return Letter.fromJson(letter);
  }
}
