import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/solicitud_db_datasource.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/data/repository/solicitud_repository_impl.dart';
import 'package:tm1/domain/repository/solicitud_repository.dart';

part 'solicitud_event.dart';
part 'solicitud_state.dart';

class SolicitudBloc extends Bloc<SolicitudEvent, SolicitudState> {
  final SolicitudRepository _solicitudRepository = SolicitudRepositoryImpl(SolicitudDbDatasource());

  SolicitudBloc() : super(SolicitudInitial()) {
    on<InsertSolicitudEvent>(_onInsertSolicitudEvent);
    on<GetSolicitudesByClientEvent>(_onGetSolicitudesByClientEvent);
  }

  Future<void> _onInsertSolicitudEvent(
    InsertSolicitudEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudLoading());

    try{
      final nuevaSolicitud = await _solicitudRepository.insertSolicitud(event.solicitud);
      emit(SolicitudLoaded(nuevaSolicitud));

    }catch (e){
      print('Error al insertar solicitud en Bloc: $e');
    }
  }

  Future<void> _onGetSolicitudesByClientEvent(
    GetSolicitudesByClientEvent event,
    Emitter<SolicitudState> emit,
  ) async {
    emit(SolicitudesByClientLoading());

    try {
      final solicitudes = await _solicitudRepository.getSolicitudesByClientId(event.clientId);
      emit(SolicitudesByClientLoaded(solicitudes));
    } catch (e) {
      print('Error al obtener solicitudes del cliente en Bloc: $e');
    }
  }
}
