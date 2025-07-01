part of 'solicitud_bloc.dart';

sealed class SolicitudState extends Equatable {
  const SolicitudState();

  @override
  List<Object> get props => [];
}

final class SolicitudInitial extends SolicitudState {}

final class SolicitudLoading extends SolicitudState {}

final class SolicitudLoaded extends SolicitudState {
  final SolicitudModel solicitud;

  const SolicitudLoaded(this.solicitud);
  @override
  List<Object> get props => [solicitud];
}

final class SolicitudesByClientLoading extends SolicitudState {}

final class SolicitudesByClientLoaded extends SolicitudState {
  final List<SolicitudModel> solicitudes;

  const SolicitudesByClientLoaded(this.solicitudes);

  @override
  List<Object> get props => [solicitudes];
}

final class SolicitudesByTecnicoLoading extends SolicitudState {}

final class SolicitudesByTecnicoLoaded extends SolicitudState {
  final List<SolicitudModel> solicitudes;

  const SolicitudesByTecnicoLoaded(this.solicitudes);

  @override
  List<Object> get props => [solicitudes];
}

final class SolicitudPhotosUploading extends SolicitudState {}

final class SolicitudPhotosLoaded extends SolicitudState {
  final List<FotoSolicitudModel> fotos;
  const SolicitudPhotosLoaded(this.fotos);
  @override
  List<Object> get props => [fotos];
}

final class SolicitudUpdating extends SolicitudState {}

final class SolicitudUpdateSuccess extends SolicitudState {
  final SolicitudModel solicitudActualizada;
  const SolicitudUpdateSuccess(this.solicitudActualizada);

  @override
  List<Object> get props => [solicitudActualizada];
}

final class SolicitudError extends SolicitudState {}
