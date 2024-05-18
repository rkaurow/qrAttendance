import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/services/auth_service.dart';

part 'auth_login_event.dart';
part 'auth_login_state.dart';
part 'auth_login_bloc.freezed.dart';

class AuthLoginBloc extends Bloc<AuthLoginEvent, AuthLoginState> {
  final AuthService authService;
  AuthLoginBloc(this.authService) : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      await Future.delayed(const Duration(seconds: 5));
      try {
        await authService.masuk(event.email, event.password);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_LogoutUser>((event, emit) async {
      emit(const _Loading());
      await Future.delayed(const Duration(seconds: 5));
      try {
        await authService.keluar();
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
