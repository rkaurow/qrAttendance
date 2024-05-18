part of 'auth_login_bloc.dart';

@freezed
class AuthLoginState with _$AuthLoginState {
  const factory AuthLoginState.initial() = _Initial;
  const factory AuthLoginState.loading() = _Loading;
  const factory AuthLoginState.success(AuthService authService) = _Success;
  const factory AuthLoginState.error(String message) = _Error;
}
