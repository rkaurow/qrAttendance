part of 'mahasiswa_bloc.dart';

@freezed
class MahasiswaState with _$MahasiswaState {
  const factory MahasiswaState.initial() = _Initial;
  const factory MahasiswaState.loading() = _Loading;
  const factory MahasiswaState.success(DataService dataService) = _Success;
  const factory MahasiswaState.error(String message) = _Error;
}
