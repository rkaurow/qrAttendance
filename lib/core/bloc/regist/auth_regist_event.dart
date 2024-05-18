part of 'auth_regist_bloc.dart';

@freezed
class AuthRegistEvent with _$AuthRegistEvent {
  const factory AuthRegistEvent.started() = _Started;
  const factory AuthRegistEvent.registeruser({
    required String nama,
    required String email,
    required String nim,
    required String prodi,
    required String password,
    required String kpassword,
  }) = _Registeruser;
  const factory AuthRegistEvent.registerdosen({
    required String nama,
    required String email,
    required String nidn,
    required String password,
  }) = _RegisterDosen;
  const factory AuthRegistEvent.updatedosen({
    required String nama,
    required String nidn,
    required String uid,
  }) = _UpdateDosen;

  const factory AuthRegistEvent.validasidosen({
    required String uid,
  }) = _ValidasiDosen;

  const factory AuthRegistEvent.unvalidasimahasiswa({
    required String uid,
  }) = _Unvalidasi;

  const factory AuthRegistEvent.updatemahasiswa({
    required String nama,
    required String nim,
  }) = _EditMahasiswa;

  const factory AuthRegistEvent.uploadPP(
      {required File fotoprofil, required String namafile}) = _UploadPP;
}
