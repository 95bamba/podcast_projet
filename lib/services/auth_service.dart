import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:podcast/models/user.dart';
import 'package:podcast/services/api_service.dart';

class AuthService {
  final ApiService _apiService;

  AuthService(this._apiService);

  /// Decode JWT token payload to extract user data
  Map<String, dynamic>? _decodeJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Decode the payload (second part)
      String payload = parts[1];
      // Add padding if needed for base64 decoding
      switch (payload.length % 4) {
        case 1:
          payload += '===';
          break;
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error decoding JWT: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'login': login,
          'password_hash': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        // Vérifier si data est null ou n'est pas un Map
        if (data == null) {
          return {
            'success': false,
            'message': 'Réponse invalide du serveur',
          };
        }

        // Extraire le token (peut être dans data directement ou dans un objet imbriqué)
        final token = data['access_token'] ?? data['token'];

        if (token == null || token.toString().isEmpty) {
          return {
            'success': false,
            'message': 'Token non trouvé dans la réponse',
          };
        }

        await _apiService.setToken(token);

        // Gérer le cas où userData peut être null
        var userData = data['user'];
        User? user;

        // Si pas de userData dans la réponse, essayer de décoder le JWT
        if (userData == null) {
          final jwtPayload = _decodeJwtPayload(token);
          if (jwtPayload != null && jwtPayload['user'] != null) {
            userData = jwtPayload['user'];
            debugPrint('User data extracted from JWT: $userData');
          }
        }

        if (userData != null && userData is Map<String, dynamic>) {
          try {
            user = User.fromJson(userData);
            // Sauvegarder le login utilisateur pour les sessions futures
            if (user.login.isNotEmpty) {
              await _apiService.setUserLogin(user.login);
              debugPrint('User login saved: ${user.login}');
            }
          } catch (e) {
            debugPrint('Error parsing user: $e');
            // Si le parsing échoue, on continue sans user
          }
        }

        return {
          'success': true,
          'token': token,
          if (user != null) 'user': user,
        };
      } else {
        return {
          'success': false,
          'message': 'Identifiants incorrects',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> signup({
    required String login,
    required String firstname,
    required String name,
    required String email,
    required String password,
    File? profileImage,
  }) async {
    try {
      final fields = {
        'login': login,
        'firstname': firstname,
        'name': name,
        'email': email,
        'password_hash': password,
      };

      final response = await _apiService.uploadFile(
        '/users/createUser',
        fields,
        profileImage,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Compte créé avec succès !',
        };
      } else if (response.statusCode == 409) {
        // Conflit - compte déjà existant
        return {
          'success': false,
          'message': 'Ce nom d\'utilisateur ou email est déjà utilisé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la création du compte',
        };
      }
    } catch (e) {
      // Vérifier si c'est une erreur DioException avec code 409
      final errorMessage = e.toString();
      if (errorMessage.contains('409') || errorMessage.contains('Conflict')) {
        return {
          'success': false,
          'message': 'Ce nom d\'utilisateur ou email est déjà utilisé',
        };
      }

      return {
        'success': false,
        'message': 'Erreur de connexion: ${errorMessage.length > 100 ? errorMessage.substring(0, 100) : errorMessage}',
      };
    }
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    await _apiService.clearUserLogin();
  }

  Future<bool> isAuthenticated() async {
    await _apiService.loadToken();
    return _apiService.hasToken;
  }

  String? getToken() {
    return _apiService.token;
  }

  Future<String?> getSavedUserLogin() async {
    return await _apiService.getUserLogin();
  }
}
