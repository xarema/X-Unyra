import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api/api_client.dart';
import '../models/checkin.dart';

final checkinsRepoProvider = Provider<CheckinsRepo>((ref) {
  return CheckinsRepo(ref.read(dioProvider));
});

class CheckinsRepo {
  final Dio _dio;
  CheckinsRepo(this._dio);

  Future<List<CheckIn>> listRecent() async {
    final res = await _dio.get('/checkins/');
    final data = (res.data as List).cast<Map<String, dynamic>>();
    return data.map(CheckIn.fromJson).toList();
  }

  Future<void> createToday({required int mood, required int stress, required int energy, String note = ''}) async {
    final today = DateTime.now();
    final dateStr = '${today.year.toString().padLeft(4, '0')}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await _dio.post('/checkins/', data: {
      'date': dateStr,
      'mood': mood,
      'stress': stress,
      'energy': energy,
      'note': note,
    });
  }
}
