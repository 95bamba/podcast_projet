import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcast/bloc/auth/auth_event.dart';
import 'package:podcast/bloc/auth/auth_state.dart';
import 'package:podcast/services/auth_service.dart';
import 'package:podcast/models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthSignupRequested>(_onAuthSignupRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final isAuthenticated = await _authService.isAuthenticated();
    if (isAuthenticated) {
      // Récupérer le token sauvegardé
      final token = _authService.getToken();
      if (token != null) {
        // Optionnel : récupérer les infos utilisateur depuis l'API
        emit(AuthAuthenticated(
          token: token,
          user: null, // Sera chargé plus tard si nécessaire
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.login(event.login, event.password);

      if (result['success'] == true) {
        final token = result['token'] as String;
        final user = result['user'] as User?;  // User peut être null

        emit(AuthAuthenticated(
          user: user,
          token: token,
        ));
      } else {
        emit(AuthError(result['message'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authService.signup(
        login: event.login,
        firstname: event.firstname,
        name: event.name,
        email: event.email,
        password: event.password,
        profileImage: event.profileImage,
      );

      if (result['success'] == true) {
        // Émettre seulement AuthSignupSuccess
        // Le listener dans signup_page.dart gérera la navigation
        emit(AuthSignupSuccess(result['message'] ?? 'Signup successful'));
      } else {
        emit(AuthError(result['message'] ?? 'Signup failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await _authService.logout();
    emit(AuthUnauthenticated());
  }
}
