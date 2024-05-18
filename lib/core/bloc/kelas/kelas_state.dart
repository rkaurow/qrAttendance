part of 'kelas_bloc.dart';

@freezed
class KelasState with _$KelasState {
  const factory KelasState.initial() = _Initial;
  const factory KelasState.loading() = _Loading;
  const factory KelasState.success(DataService dataService) = _Success;
  const factory KelasState.error(String message) = _Error;
  const factory KelasState.loaded(List<Kelas> kelas) = _Loaded;
}
