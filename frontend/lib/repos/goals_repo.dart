import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/goal.dart';

final goalsRepoProvider = Provider<GoalsRepo>((ref) {
  return GoalsRepo(ref.read(dioProvider));
});

class GoalsRepo {
  final Dio _dio;
  GoalsRepo(this._dio);

  Future<List<Goal>> listGoals() async {
    final res = await _dio.get('/goals/');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(Goal.fromJson).toList();
  }

  Future<void> createGoal({required String title, String whyForUs = ''}) async {
    await _dio.post('/goals/', data: {'title': title, 'why_for_us': whyForUs});
  }
}
