import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://51.254.204.25:2000';
  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor for token and logging
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          // Debug logging
          print('DEBUG API Request: ${options.method} ${options.path}');
          print('DEBUG Headers: ${options.headers}');
          print('DEBUG Data: ${options.data}');
          return handler.next(options);
        },
        onError: (error, handler) async {
          print('DEBUG API Error: ${error.response?.statusCode}');
          print('DEBUG Error Data: ${error.response?.data}');
          if (error.response?.statusCode == 401) {
            // Token expired, clear it
            await clearToken();
          }
          return handler.next(error);
        },
        onResponse: (response, handler) async {
          print('DEBUG API Response: ${response.statusCode}');
          print('DEBUG Response Data: ${response.data}');
          return handler.next(response);
        },
      ),
    );
  }

  // Token management
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  String? get token => _token;
  bool get hasToken => _token != null;

  // Generic methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // Download file as bytes
  Future<Response> downloadFile(String path) async {
    return await _dio.get(
      path,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );
  }

  // Download file as bytes with query parameters
  Future<Response> downloadFileWithQuery(
    String path,
    Map<String, dynamic> queryParameters,
  ) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) => status! < 500,
      ),
    );
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }

  // Multipart upload (for files)
  Future<Response> uploadFile(
    String path,
    Map<String, dynamic> fields,
    File? file, {
    String fileFieldName = 'file',
    String method = 'POST', // Par défaut POST, mais peut être PUT, PATCH, etc.
  }) async {
    // Créer une map complète pour FormData
    Map<String, dynamic> formDataMap = Map.from(fields);

    if (file != null) {
      // Déterminer le type MIME en fonction de l'extension du fichier
      String? contentType;
      final fileName = file.path.split('/').last.toLowerCase();

      if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        contentType = 'image/jpeg';
      } else if (fileName.endsWith('.png')) {
        contentType = 'image/png';
      } else if (fileName.endsWith('.gif')) {
        contentType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        contentType = 'image/webp';
      } else if (fileName.endsWith('.bmp')) {
        contentType = 'image/bmp';
      } else if (fileName.endsWith('.mp3')) {
        contentType = 'audio/mpeg';
      } else if (fileName.endsWith('.m4a')) {
        contentType = 'audio/mp4';
      } else if (fileName.endsWith('.wav')) {
        contentType = 'audio/wav';
      } else if (fileName.endsWith('.aac')) {
        contentType = 'audio/aac';
      } else if (fileName.endsWith('.ogg')) {
        contentType = 'audio/ogg';
      } else if (fileName.endsWith('.flac')) {
        contentType = 'audio/flac';
      }

      formDataMap[fileFieldName] = await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: contentType != null
            ? MediaType.parse(contentType)
            : null,
      );
    }

    FormData formData = FormData.fromMap(formDataMap);

    return await _dio.request(
      path,
      data: formData,
      options: Options(
        method: method,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
