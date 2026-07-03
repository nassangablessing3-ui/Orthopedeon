import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  /// Since Flutter Web and FastAPI are served from the SAME domain on Render,
  /// we can use a relative base path — no CORS config needed at all.
  ///
  /// For local development with Android emulator: http://10.0.2.2:8000/api/v1
  /// For local development with physical device:  http://<your-lan-ip>:8000/api/v1
  /// Production (same-origin via Render):         /api/v1
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '/api/v1',    // used in Flutter Web production build
  );

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
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  // ── Auth ──────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> register({
    required String email,
    required String fullName,
    required String password,
    required List<String> disabilityTypes,
  }) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'full_name': fullName,
      'password': password,
      'disability_types': disabilityTypes,
    });
    await _storage.write(key: 'access_token', value: response.data['access_token']);
    return response.data;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    await _storage.write(key: 'access_token', value: response.data['access_token']);
    return response.data;
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
  }

  // ── Wellness ──────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> logMood({
    required int score,
    String? emoji,
    String? notes,
  }) async {
    final response = await _dio.post('/wellness/mood', data: {
      'mood_score': score,
      'mood_emoji': emoji,
      'notes': notes,
    });
    return response.data;
  }

  static Future<List<dynamic>> getMoodHistory() async {
    final response = await _dio.get('/wellness/mood');
    return response.data;
  }

  static Future<Map<String, dynamic>> saveJournal({
    required String content,
    String entryType = 'gratitude',
  }) async {
    final response = await _dio.post('/wellness/journal', data: {
      'content': content,
      'entry_type': entryType,
    });
    return response.data;
  }

  static Future<Map<String, dynamic>> createReminder({
    required String title,
    required String remindAt,
    String? description,
    String isRecurring = 'none',
  }) async {
    final response = await _dio.post('/wellness/reminders', data: {
      'title': title,
      'remind_at': remindAt,
      'description': description,
      'is_recurring': isRecurring,
    });
    return response.data;
  }

  // ── Social ────────────────────────────────────────────────────────────────
  static Future<List<dynamic>> getGroups({String? category}) async {
    final response = await _dio.get('/social/groups',
        queryParameters: category != null ? {'category': category} : null);
    return response.data;
  }

  static Future<void> joinGroup(String groupId) async {
    await _dio.post('/social/groups/$groupId/join');
  }

  static Future<List<dynamic>> getMessages(String groupId) async {
    final response = await _dio.get('/social/groups/$groupId/messages');
    return response.data;
  }

  static Future<Map<String, dynamic>> sendMessage({
    required String groupId,
    required String content,
  }) async {
    final response = await _dio.post('/social/groups/$groupId/messages',
        data: {'content': content, 'message_type': 'text'});
    return response.data;
  }

  // ── AI ────────────────────────────────────────────────────────────────────
  static Future<Map<String, dynamic>> voiceCommand({
    required String text,
    String context = 'dashboard',
  }) async {
    final response = await _dio.post('/ai/voice', data: {
      'text': text,
      'context': context,
    });
    return response.data;
  }

  static Future<Map<String, dynamic>> performOCR(String imageBase64) async {
    final response =
        await _dio.post('/ai/ocr', data: {'image_base64': imageBase64});
    return response.data;
  }
}
