import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/categories_db_datasource.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final _datasource = CategoriesDbDatasource();

  CategoriesCubit() : super(CategoriesInitial());

  Future<void> getCategories() async {
    emit(CategoriesLoading());

    try {
      final data = await _datasource.getCategories();
      final mapped = data.map<Map>((e) => {
        'nombre': e.nombre,
        'id': e.id,
      }).toList();
      emit(CategoriesLoaded(categories: mapped));
    } catch (e, st) {
      log('Error al obtener categorías: $e\n$st');
      emit(CategoriesError());
    }
  }

  void renderer() {
    emit(CategoriesInitial());
  }
}
