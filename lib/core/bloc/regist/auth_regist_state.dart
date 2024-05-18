part of 'auth_regist_bloc.dart';

@freezed
class AuthRegistState with _$AuthRegistState {
  const factory AuthRegistState.initial() = _Initial;
  const factory AuthRegistState.loading() = _Loading;
  const factory AuthRegistState.success(AuthService authService) = _Success;
  const factory AuthRegistState.upload(String downloadurl) = _Uploadgambar;
  const factory AuthRegistState.error(String message) = _Error;
}
