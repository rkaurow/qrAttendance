part of 'rekap_reset_bloc.dart';

@freezed
class RekapResetEvent with _$RekapResetEvent {
  const factory RekapResetEvent.started() = _Started;
  const factory RekapResetEvent.rekap({
    required String idkelas,
  }) = _RekapAndReset;
}
