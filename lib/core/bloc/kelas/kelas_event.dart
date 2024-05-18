part of 'kelas_bloc.dart';

@freezed
class KelasEvent with _$KelasEvent {
  const factory KelasEvent.started() = _Started;
  const factory KelasEvent.tambahkelas({required String namakelas}) =
      _TambahKelas;
  const factory KelasEvent.getkelas() = _Getkelas;
}
