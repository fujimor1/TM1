import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/district_db_datasource.dart'; // ruta según tu estructura

part 'district_state.dart';

class DistrictCubit extends Cubit<DistrictState> {
  final _datasource = DistrictDbDatasource();

  DistrictCubit() : super(DistrictInitial());

  Future<void> getDistricts() async {
    emit(DistrictLoading());

    try {
      final data = await _datasource.getDistrict();
      final mapped = data.map<Map>((e) => {
        'nombre': e.nombre,
        'id': e.id,
      }).toList();
      emit(DistrictLoaded(district: mapped));
    } catch (e, st) {
      log('Error al obtener distritos: $e\n$st');
      emit(DistrictError());
    }
  }

  void renderer() {
    emit(DistrictInitial());
  }
}
