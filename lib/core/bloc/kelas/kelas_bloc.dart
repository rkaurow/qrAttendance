import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:viko_absensi/models/kelas_data_model.dart';
import 'package:viko_absensi/services/data_services.dart';

part 'kelas_event.dart';
part 'kelas_state.dart';
part 'kelas_bloc.freezed.dart';

class KelasBloc extends Bloc<KelasEvent, KelasState> {
  final DataService dataService;
  KelasBloc(this.dataService) : super(const _Initial()) {
    on<_TambahKelas>((event, emit) async {
      emit(const _Loading());
      try {
        await dataService.tambahkelas(event.namakelas);
        emit(_Success(dataService));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });

    on<_Getkelas>((event, emit) async {
      emit(const _Loading());
      try {
        final data = await dataService.getKelas();
        emit(_Loaded(data));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
