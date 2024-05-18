import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/services/data_services.dart';

part 'mahasiswa_event.dart';
part 'mahasiswa_state.dart';
part 'mahasiswa_bloc.freezed.dart';

class MahasiswaBloc extends Bloc<MahasiswaEvent, MahasiswaState> {
  final DataService dataService;
  MahasiswaBloc(this.dataService) : super(const _Initial()) {
    on<_Tambahmahasiswa>((event, emit) async {
      emit(const _Loading());
      try {
        await dataService.tambahsiswa(
          event.idkelas,
          event.nama,
          event.nim,
          event.prodi,
          event.uid,
        );
        emit(_Success(dataService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
