part of 'qrscan_bloc.dart';

@freezed
class QrscanState with _$QrscanState {
  const factory QrscanState.initial() = _Initial;
  const factory QrscanState.loading() = _Loading;
  const factory QrscanState.success(DataService dataService) = _Success;
  const factory QrscanState.error(String message) = _Error;
}
