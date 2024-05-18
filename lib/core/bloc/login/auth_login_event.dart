part of 'auth_login_bloc.dart';

@freezed
class AuthLoginEvent with _$AuthLoginEvent {
  const factory AuthLoginEvent.started() = _Started;
  const factory AuthLoginEvent.logout() = _LogoutUser;
  const factory AuthLoginEvent.login({
    required String email,
    required String password,
  }) = _Login;
}
