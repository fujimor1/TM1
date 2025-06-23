import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/foto_solicitud_db_datasource.dart';
import 'package:tm1/data/datasource/solicitud_db_datasource.dart';
import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/data/repository/foto_solicitud_repository_impl.dart';
import 'package:tm1/data/repository/solicitud_repository_impl.dart';
import 'package:tm1/domain/repository/foto_solicitud_repository.dart';
import 'package:tm1/domain/repository/solicitud_repository.dart';

part 'solicitud_event.dart';
part 'solicitud_state.dart';

class SolicitudBloc extends Bloc<SolicitudEvent, SolicitudState> {
  final SolicitudRepository _solicitudRepository = SolicitudRepositoryImpl(
    SolicitudDbDatasource(),
  );
  final FotoSolicitudRepository _fotoSolicitudRepository =
      FotoSolicitudRepositoryImpl(FotoSolicitudDbDatasource());

  SolicitudBloc() : super(SolicitudInitial()) {
    on<InsertSolicitudEvent>(_onInsertSolicitudEvent);
    on<GetSolicitudesByClientEvent>(_onGetSolicitudesByClientEvent);
    on<UploadSolicitudPhotosEvent>(_onUploadSolicitudPhotosEvent);
    on<GetSolicitudesByTecnicoEvent>(_onGetSolicitudesByTecnicoEvent);
    on<UpdateSolicitudEvent>(_onUpdateSolicitudEvent);
  }

  Future<void> _onInsertSolicitudEvent(
    InsertSolicitudEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudLoading());

    try {
      final nuevaSolicitud = await _solicitudRepository.insertSolicitud(
        event.solicitud,
      );
      emit(SolicitudLoaded(nuevaSolicitud));
    } catch (e) {
      print('Error al insertar solicitud en Bloc: $e');
    }
  }

  Future<void> _onGetSolicitudesByClientEvent(
    GetSolicitudesByClientEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudesByClientLoading());

    try {
      final solicitudes = await _solicitudRepository.getSolicitudesByClientId(
        event.clientId,
      );
      emit(SolicitudesByClientLoaded(solicitudes));
    } catch (e) {
      print('Error al obtener solicitudes del cliente en Bloc: $e');
    }
  }

  Future<void> _onUploadSolicitudPhotosEvent(
    UploadSolicitudPhotosEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    try {
      await _fotoSolicitudRepository.uploadFotos(
        event.solicitudId,
        event.photoPaths,
      );
      // final SolicitudModel solicitudCompleta = await _solicitudRepository.getSolicitudById(event.solicitudId);

      // emit(SolicitudLoaded(solicitudCompleta));
    } catch (e) {
      print('Error al obtener solicitudes del cliente en Bloc: $e');
    }
  }

  Future<void> _onGetSolicitudesByTecnicoEvent(
    GetSolicitudesByTecnicoEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudesByTecnicoLoading());

    try {
      final solicitudes = await _solicitudRepository.getSolicitudesByTecnicoId(
        event.tecnicoId,
      );
      emit(SolicitudesByTecnicoLoaded(solicitudes));
    } catch (e) {
      print('Error al obtener solicitudes del tecnico en Bloc: $e');
      emit(SolicitudError());
    }
  }

  
  Future<void> _onUpdateSolicitudEvent(
    UpdateSolicitudEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudUpdating());
    try {
      final solicitudActualizada = await _solicitudRepository.updateSolicitud(
        event.solicitudId,
        event.data,
      );
      emit(SolicitudUpdateSuccess(solicitudActualizada));
      if (state is SolicitudesByTecnicoLoaded) {
          final currentState = state as SolicitudesByTecnicoLoaded;
          final List<SolicitudModel> updatedList = currentState.solicitudes.map((solicitud) {
              return solicitud.id == event.solicitudId ? solicitudActualizada : solicitud;
          }).toList();
          emit(SolicitudesByTecnicoLoaded(updatedList));
      }
    } catch (e) {
      print('Error al actualizar la solicitud en Bloc: $e');
    }
  }

}
