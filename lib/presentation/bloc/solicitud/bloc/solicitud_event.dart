part of 'solicitud_bloc.dart';

sealed class SolicitudEvent extends Equatable {
  const SolicitudEvent();

  @override
  List<Object> get props => [];
}

class InsertSolicitudEvent extends SolicitudEvent {
  final Map<String, dynamic> solicitud;

  const InsertSolicitudEvent(this.solicitud);
  @override
  List<Object> get props => [solicitud];
}

class GetSolicitudesByClientEvent extends SolicitudEvent {
  final int clientId;

  const GetSolicitudesByClientEvent(this.clientId);

  @override
  List<Object> get props => [clientId];
}

class GetSolicitudesByTecnicoEvent extends SolicitudEvent {
  final int tecnicoId;

  const GetSolicitudesByTecnicoEvent(this.tecnicoId);

  @override
  List<Object> get props => [tecnicoId];
}

class UploadSolicitudPhotosEvent extends SolicitudEvent {
  final int solicitudId;
  final List<String> photoPaths;

  const UploadSolicitudPhotosEvent({
    required this.solicitudId,
    required this.photoPaths,
  });

  @override
  List<Object> get props => [solicitudId, photoPaths];
}

class UpdateSolicitudEvent extends SolicitudEvent {
  final int solicitudId;
  final Map<String, dynamic> data;

  const UpdateSolicitudEvent({required this.solicitudId, required this.data});

  @override
  List<Object> get props => [solicitudId, data];
}