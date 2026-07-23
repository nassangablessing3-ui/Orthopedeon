import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL', defaultValue: '/api/v1');

  static const _storage = FlutterSecureStorage();
  static late Dio _dio;

  static void init() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  static Future<Map<String, dynamic>> register({required String email, required String fullName, required String password, required List<String> disabilityTypes}) async {
    final r = await _dio.post('/auth/register', data: {'email': email, 'full_name': fullName, 'password': password, 'disability_types': disabilityTypes});
    await _storage.write(key: 'access_token', value: r.data['access_token']);
    return r.data;
  }

  static Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final r = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    await _storage.write(key: 'access_token', value: r.data['access_token']);
    return r.data;
  }

  static Future<void> logout() async => _storage.delete(key: 'access_token');
  static Future<String?> getToken() async => _storage.read(key: 'access_token');

  static Future<Map<String, dynamic>> logMood({required int score, String? emoji, String? notes}) async {
    final r = await _dio.post('/wellness/mood', data: {'mood_score': score, 'mood_emoji': emoji, 'notes': notes});
    return r.data;
  }

  static Future<Map<String, dynamic>> saveJournal({required String content, String entryType = 'gratitude'}) async {
    final r = await _dio.post('/wellness/journal', data: {'content': content, 'entry_type': entryType});
    return r.data;
  }

  static Future<List<dynamic>> getGroups() async {
    final r = await _dio.get('/social/groups');
    return r.data;
  }

  static Future<void> joinGroup(String id) async => _dio.post('/social/groups/$id/join');

  static Future<Map<String, dynamic>> voiceCommand({required String text, String context = 'home'}) async {
    final r = await _dio.post('/ai/voice', data: {'text': text, 'context': context});
    return r.data;
  }
}
