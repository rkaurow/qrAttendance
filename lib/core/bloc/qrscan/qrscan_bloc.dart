import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/services/data_services.dart';

part 'qrscan_event.dart';
part 'qrscan_state.dart';
part 'qrscan_bloc.freezed.dart';

class QrscanBloc extends Bloc<QrscanEvent, QrscanState> {
  final DataService dataService;
  QrscanBloc(this.dataService) : super(const _Initial()) {
    on<_AbsenMahasiswa>((event, emit) async {
      emit(const _Loading());
      await Future.delayed(const Duration(seconds: 3));
      try {
        await dataService.updateAbsen(event.kelasid, event.uid);
        emit(_Success(dataService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
