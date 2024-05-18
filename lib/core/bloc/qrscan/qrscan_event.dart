part of 'qrscan_bloc.dart';

@freezed
class QrscanEvent with _$QrscanEvent {
  const factory QrscanEvent.started() = _Started;
  const factory QrscanEvent.absen({
    required String kelasid,
    required String uid,
  }) = _AbsenMahasiswa;
}
