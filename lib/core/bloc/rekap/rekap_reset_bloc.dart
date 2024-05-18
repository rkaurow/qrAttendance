import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/services/data_services.dart';

part 'rekap_reset_event.dart';
part 'rekap_reset_state.dart';
part 'rekap_reset_bloc.freezed.dart';

class RekapResetBloc extends Bloc<RekapResetEvent, RekapResetState> {
  final DataService dataService;
  RekapResetBloc(this.dataService) : super(const _Initial()) {
    on<_RekapAndReset>((event, emit) async {
      emit(const _Loading());
      try {
        await dataService.rekap(event.idkelas);
        emit(_Succees(dataService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
