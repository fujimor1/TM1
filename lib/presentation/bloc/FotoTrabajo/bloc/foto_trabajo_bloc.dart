import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/foto_trabajo_db_datasource.dart';
import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';
import 'package:tm1/data/repository/foto_trabajo_repository_impl.dart';
import 'package:tm1/domain/repository/foto_trabajo_repository.dart';

part 'foto_trabajo_event.dart';
part 'foto_trabajo_state.dart';

class FotoTrabajoBloc extends Bloc<FotoTrabajoEvent, FotoTrabajoState> {
  final FotoTrabajoRepository _fotoTrabajoRepository =
      FotoTrabajoRepositoryImpl(FotoTrabajoDbDatasource());

  FotoTrabajoBloc() : super(FotoTrabajoInitial()) {
    on<GetFotosByTecnicoAndCategoriaEvent>(_onGetFotosByTecnicoAndCategoriaEvent);
    on<UploadFotoTrabajoEvent>(_onUploadFotoTrabajoEvent);
    on<DeleteFotoTrabajoEvent>(_onDeleteFotoTrabajoEvent);
  }

  Future<void> _onGetFotosByTecnicoAndCategoriaEvent(
    GetFotosByTecnicoAndCategoriaEvent event,
    Emitter<FotoTrabajoState> emit,
  ) async {
    emit(FotoTrabajoLoading());
    try {
      final List<FotoTrabajoModel> fotos = await _fotoTrabajoRepository
          .getFotosByTecnicoAndCategoriaId(event.tecnicoId, event.categoriaId);

      emit(FotoTrabajoLoaded(fotos));
    } catch (e) {
      emit(FotoTrabajoError('Error al cargar las fotos de trabajo: $e'));
    }
  }

  Future<void> _onUploadFotoTrabajoEvent(
    UploadFotoTrabajoEvent event,
    Emitter<FotoTrabajoState> emit,
  ) async {
    emit(FotoTrabajoUploading());

    try {
      final nuevaFoto = await _fotoTrabajoRepository.uploadFotoTrabajo(
        tecnicoId: event.tecnicoId,
        categoriaId: event.categoriaId,
        fotoPath: event.fotoPath,
      );

      emit(FotoTrabajoUploadSuccess(nuevaFoto));

      // Importante: Después de subir la foto, disparamos el evento para
      // refrescar la lista de fotos y mantener la UI actualizada.
      add(
        GetFotosByTecnicoAndCategoriaEvent(
          tecnicoId: event.tecnicoId,
          categoriaId: event.categoriaId,
        ),
      );
    } catch (e) {
      emit(FotoTrabajoError('Error al subir la foto: $e'));
    }
  }

  Future<void> _onDeleteFotoTrabajoEvent(
    DeleteFotoTrabajoEvent event,
    Emitter<FotoTrabajoState> emit,
  ) async {
    emit(FotoTrabajoDeleting());
    try {
      await _fotoTrabajoRepository.deleteFotoTrabajo(event.fotoId);

      emit(FotoTrabajoDeleteSuccess());

      // Refresca la lista después de eliminar la foto para actualizar la UI
      add(GetFotosByTecnicoAndCategoriaEvent(
        tecnicoId: event.tecnicoId,
        categoriaId: event.categoriaId,
      ));

    } catch (e) {
      emit(FotoTrabajoError('Error al eliminar la foto: $e'));
    }
  }

}
