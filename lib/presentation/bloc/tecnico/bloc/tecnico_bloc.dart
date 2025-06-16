// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/distritotecnico_db_datasource.dart';
import 'package:tm1/data/datasource/tecnico_db_datasource.dart';
import 'package:tm1/data/datasource/tecnicocategoria_db_datasource.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/data/repository/distritotecnico_repository_impl.dart';
import 'package:tm1/data/repository/tecnico_repository_impl.dart';
import 'package:tm1/data/repository/tecnicocategoria_repository_impl.dart';
import 'package:tm1/domain/repository/distritotecnico_repository.dart';
import 'package:tm1/domain/repository/tecnico_repository.dart';
import 'package:tm1/domain/repository/tecnicocategoria_repository.dart';

part 'tecnico_event.dart';
part 'tecnico_state.dart';

class TecnicoBloc extends Bloc<TecnicoEvent, TecnicoState> {
  final TecnicoRepository _tecnicoRepository = TecnicoRepositoryImpl(TecnicoDbDatasource());
  final TecnicocategoriaRepository _tecnicoCategoriaRepository = TecnicocategoriaRepositoryImpl(TecnicocategoriaDbDatasource());
  final DistritotecnicoRepository _distritoTecnicoRepository = DistritotecnicoRepositoryImpl(DistritotecnicoDbDatasource());

  TecnicoBloc() : super(TecnicoInitial()) {
    on<InsertTecnicoEvent>(_onInsertTecnicoEvent);
    on<LoadTecnicosEvent>(_onLoadTecnicosEvent);
    on<LoadTecnicosByCategoryAndDistrict>(_onLoadTecnicosByCategoryAndDistrict);
  }

  Future<void> _onInsertTecnicoEvent(
    InsertTecnicoEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());
    
    try{
      final Map<String, dynamic> tecnico = {
        'usuario_id': event.usuarioId,
      };
      final TecnicoModel nuevoTecnico = await _tecnicoRepository.insertTecnico(tecnico);

      final int tecnicoId = nuevoTecnico.usuario.id!;

      final List<Future<void>> relationFutures = [];

      for (int categoriaId in event.categoryIds) {
        relationFutures.add(
          _tecnicoCategoriaRepository.insertTecnicoCategoria({
            'tecnico': tecnicoId,
            'categoria': categoriaId,
          }).then((_) {
            // ignore: duplicate_ignore
            // ignore: avoid_print
            print('Relación tecnico-categoria ($tecnicoId-$categoriaId) agregada.');
          }).catchError((e) {
            print('Error adding tecnico-categoria ($tecnicoId-$categoriaId): $e');
          })
        );
      }

      for (int distritoId in event.districtIds) {
        relationFutures.add(
          _distritoTecnicoRepository.postDistritoTecnico({
            'tecnico': tecnicoId,
            'distrito': distritoId,
          }).then((_) {
            print('Relación distrito-tecnico ($tecnicoId-$distritoId) agregada.');
          }).catchError((e) {
            print('Error adding distrito-tecnico ($tecnicoId-$distritoId): $e');
          })
        );
      }

      await Future.wait(relationFutures);
      emit(TecnicoLoaded(nuevoTecnico));

    } catch (e){
      print('Error en TecnicoBloc: $e');
      emit(TecnicoError());
    }

  }

  Future<void> _onLoadTecnicosEvent(
    LoadTecnicosEvent event,
    Emitter<TecnicoState> emit,
  ) async{
    emit(TecnicoLoading());
    
    try {
      final List<TecnicoModel> tecnicos = await _tecnicoRepository.getTecnicos();
      emit(TecnicosListLoaded(tecnicos));
    } catch (e){
    }
  }

  Future<void> _onLoadTecnicosByCategoryAndDistrict(
    LoadTecnicosByCategoryAndDistrict event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());
    try {
      final List<TecnicoModel> tecnicos = await _tecnicoRepository.getTecnicos(
        categoryName: event.categoryName,
        districtName: event.districtName,
      );
      print('TecnicoBloc: Received ${tecnicos.length} filtered tecnicos from datasource.');
      if (tecnicos.isEmpty) {
          print('TecnicoBloc: No tecnicos found after client-side filtering.');
      }
      emit(TecnicosListLoaded(tecnicos));
    } catch (e) {

    }
  }
}