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