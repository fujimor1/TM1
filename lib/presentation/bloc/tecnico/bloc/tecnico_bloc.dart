// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/distritotecnico_db_datasource.dart';
import 'package:tm1/data/datasource/tecnico_db_datasource.dart';
import 'package:tm1/data/datasource/tecnicocategoria_db_datasource.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/data/model/tecnicocategoria/tecnicocategoria_model.dart';
import 'package:tm1/data/repository/distritotecnico_repository_impl.dart';
import 'package:tm1/data/repository/tecnico_repository_impl.dart';
import 'package:tm1/data/repository/tecnicocategoria_repository_impl.dart';
import 'package:tm1/domain/repository/distritotecnico_repository.dart';
import 'package:tm1/domain/repository/tecnico_repository.dart';
import 'package:tm1/domain/repository/tecnicocategoria_repository.dart';

part 'tecnico_event.dart';
part 'tecnico_state.dart';

class TecnicoBloc extends Bloc<TecnicoEvent, TecnicoState> {
  final TecnicoRepository _tecnicoRepository = TecnicoRepositoryImpl(
    TecnicoDbDatasource(),
  );
  final TecnicocategoriaRepository _tecnicoCategoriaRepository =
      TecnicocategoriaRepositoryImpl(TecnicocategoriaDbDatasource());
  final DistritotecnicoRepository _distritoTecnicoRepository =
      DistritotecnicoRepositoryImpl(DistritotecnicoDbDatasource());
  TecnicoBloc() : super(TecnicoInitial()) {
    on<InsertTecnicoEvent>(_onInsertTecnicoEvent);
    on<LoadTecnicosEvent>(_onLoadTecnicosEvent);
    on<LoadTecnicosByCategoryAndDistrict>(_onLoadTecnicosByCategoryAndDistrict);
    on<UpdateTecnicoProfileEvent>(_onUpdateTecnicoProfileEvent);
    on<GetTecnicoByIdEvent>(_onGetTecnicoByIdEvent);
    on<PatchTecnicoCategoriaEvent>(_onPatchTecnicoCategoriaEvent);
  }

  Future<void> _onInsertTecnicoEvent(
    InsertTecnicoEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());

    try {
      final Map<String, dynamic> tecnico = {'usuario_id': event.usuarioId};
      final TecnicoModel nuevoTecnico = await _tecnicoRepository.insertTecnico(
        tecnico,
      );

      final int tecnicoId = nuevoTecnico.usuario.id!;

      final List<Future<void>> relationFutures = [];

      for (int categoriaId in event.categoryIds) {
        relationFutures.add(
          _tecnicoCategoriaRepository
              .insertTecnicoCategoria({
                'tecnico': tecnicoId,
                'categoria': categoriaId,
              })
              .then((_) {
                print(
                  'Relación tecnico-categoria ($tecnicoId-$categoriaId) agregada.',
                );
              })
              .catchError((e) {
                print(
                  'Error adding tecnico-categoria ($tecnicoId-$categoriaId): $e',
                );
              }),
        );
      }

      for (int distritoId in event.districtIds) {
        relationFutures.add(
          _distritoTecnicoRepository
              .postDistritoTecnico({
                'tecnico': tecnicoId,
                'distrito': distritoId,
              })
              .then((_) {
                print(
                  'Relación distrito-tecnico ($tecnicoId-$distritoId) agregada.',
                );
              })
              .catchError((e) {
                print(
                  'Error adding distrito-tecnico ($tecnicoId-$distritoId): $e',
                );
              }),
        );
      }

      await Future.wait(relationFutures);
      emit(TecnicoLoaded(nuevoTecnico));
    } catch (e) {
      print('Error en TecnicoBloc: $e');
      emit(TecnicoError('Error al crear el técnico: ${e.toString()}'));
    }
  }

  Future<void> _onLoadTecnicosEvent(
    LoadTecnicosEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());

    try {
      final List<TecnicoModel> tecnicos =
          await _tecnicoRepository.getTecnicos();
      emit(TecnicosListLoaded(tecnicos));
    } catch (e) {}
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
      print(
        'TecnicoBloc: Received ${tecnicos.length} filtered tecnicos from datasource.',
      );
      if (tecnicos.isEmpty) {
        print('TecnicoBloc: No tecnicos found after client-side filtering.');
      }
      emit(TecnicosListLoaded(tecnicos));
    } catch (e) {
      print('Error en TecnicoBloc (UpdateTecnicoProfileEvent): $e');
    }
  }

  Future<void> _onUpdateTecnicoProfileEvent(
    UpdateTecnicoProfileEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());

    try {
      final TecnicoModel updatedTecnico = await _tecnicoRepository
          .updateTecnicoProfile(event.tecnicoId, event.data);
      print(
        'Perfil de técnico actualizado exitosamente: ${updatedTecnico.usuario.username}',
      );
      emit(TecnicoLoaded(updatedTecnico));
    } catch (e) {
      print('Error en TecnicoBloc (UpdateTecnicoProfileEvent): $e');
    }
  }

  Future<void> _onGetTecnicoByIdEvent(
    GetTecnicoByIdEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    emit(TecnicoLoading());

    try {
      final TecnicoModel tecnico = await _tecnicoRepository.getTecnicoById(
        event.tecnicoId,
      );
      print(
        'Técnico cargado por ID: ${tecnico.usuario.id} - ${tecnico.usuario.username}',
      );
      emit(TecnicoLoaded(tecnico));
    } catch (e) {
      print('Error en TecnicoBloc (GetTecnicoByIdEvent): $e');
      emit(TecnicoError('Error al crear el técnico: ${e.toString()}'));
    }
  }

  // Future<void> _onPatchTecnicoCategoriaEvent(
  //   PatchTecnicoCategoriaEvent event,
  //   Emitter<TecnicoState> emit,
  // ) async {
  //   emit(TecnicoLoading());

  //   try {
  //     final TecnicoCategoriaModel? updatedTecnicoCategoria =
  //         await _tecnicoCategoriaRepository.patchTecnicoCategoria(
  //           event.tecnicocategoriaData,
  //           event.idTecnicoCategoria,
  //         );

  //     if (updatedTecnicoCategoria != null) {
  //       print('Relación Tecnico-Categoría actualizada exitosamente.');

  //       if (state is TecnicoLoaded) {
  //         final int? tecnicoUserId =
  //             (state as TecnicoLoaded).tecnico.usuario.id;
  //         if (tecnicoUserId != null) {
  //           add(GetTecnicoByIdEvent(tecnicoUserId));
  //           return;
  //         }
  //       }
  //       print(
  //         'No se pudo determinar el ID del técnico para recargar después de la actualización de categoría.',
  //       );
  //       emit(TecnicoError());
  //     } else {
  //       print(
  //         'No se pudo actualizar la relación Tecnico-Categoría (updatedTecnicoCategoria es null).',
  //       );
  //       emit(TecnicoError());
  //     }
  //   } catch (e) {
  //     print('Error en TecnicoBloc (PatchTecnicoCategoriaEvent): $e');
  //     emit(TecnicoError());
  //   }
  // }

  Future<void> _onPatchTecnicoCategoriaEvent(
    PatchTecnicoCategoriaEvent event,
    Emitter<TecnicoState> emit,
  ) async {
    try {
      final TecnicoCategoriaModel? updatedTecnicoCategoria =
          await _tecnicoCategoriaRepository.patchTecnicoCategoria(
            event.tecnicocategoriaData,
            event.idTecnicoCategoria,
          );

      if (updatedTecnicoCategoria != null) {
        print('Relación Tecnico-Categoría actualizada exitosamente.');
        add(GetTecnicoByIdEvent(event.tecnicoPrincipalId));
      } else {
        print(
          'No se pudo actualizar la relación Tecnico-Categoría (updatedTecnicoCategoria es null).',
        );
      }
    } catch (e) {
      print('Error en TecnicoBloc (PatchTecnicoCategoriaEvent): $e');
    }
  }
}
