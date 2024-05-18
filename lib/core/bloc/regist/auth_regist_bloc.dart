import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/services/auth_service.dart';

part 'auth_regist_event.dart';
part 'auth_regist_state.dart';
part 'auth_regist_bloc.freezed.dart';

class AuthRegistBloc extends Bloc<AuthRegistEvent, AuthRegistState> {
  final AuthService authService;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  AuthRegistBloc(this.authService) : super(const _Initial()) {
    on<_Registeruser>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.daftarmahasiswa(
            event.nama, event.nim, event.prodi, event.email, event.password);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_RegisterDosen>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.daftardosen(
            event.nama, event.nidn, event.email, event.password);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_UpdateDosen>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.updateDosen(event.uid, event.nama, event.nidn);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_ValidasiDosen>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.validasiDosen(event.uid);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_Unvalidasi>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.unvalidasiDosen(event.uid);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_EditMahasiswa>((event, emit) async {
      emit(const _Loading());
      try {
        await authService.updateprofilmahasiswa(event.nama, event.nim);
        emit(_Success(authService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
    on<_UploadPP>((event, emit) async {
      emit(const _Loading());
      try {
        final imagepath = 'fotoprofil/${event.namafile}.jpg';
        final uploadtask =
            _storage.ref().child(imagepath).putFile(event.fotoprofil);
        final snapshot = await uploadtask.whenComplete(() => null);
        final downloadurl = await snapshot.ref.getDownloadURL();
        emit(_Uploadgambar(downloadurl));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
