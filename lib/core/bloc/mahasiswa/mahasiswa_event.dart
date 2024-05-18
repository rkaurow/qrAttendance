part of 'mahasiswa_bloc.dart';

@freezed
class MahasiswaEvent with _$MahasiswaEvent {
  const factory MahasiswaEvent.started() = _Started;
  const factory MahasiswaEvent.tambahmahasiswa({
    required String nama,
    required String uid,
    required String nim,
    required String prodi,
    required String idkelas,
  }) = _Tambahmahasiswa;
}
