part of 'rekap_reset_bloc.dart';

@freezed
class RekapResetState with _$RekapResetState {
  const factory RekapResetState.initial() = _Initial;
  const factory RekapResetState.loading() = _Loading;
  const factory RekapResetState.success(DataService dataService) = _Succees;
  const factory RekapResetState.error(String message) = _Error;
}
