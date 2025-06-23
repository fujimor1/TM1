part of 'foto_trabajo_bloc.dart';

sealed class FotoTrabajoState extends Equatable {
  const FotoTrabajoState();
  
  @override
  List<Object> get props => [];
}

final class FotoTrabajoInitial extends FotoTrabajoState {}

final class FotoTrabajoLoading extends FotoTrabajoState {}

final class FotoTrabajoLoaded extends FotoTrabajoState {
  final List<FotoTrabajoModel> fotos;

  const FotoTrabajoLoaded(this.fotos);

  @override
  List<Object> get props => [fotos];
}

final class FotoTrabajoUploading extends FotoTrabajoState {}

/// Indica que la foto se subió con éxito y devuelve la nueva foto.
final class FotoTrabajoUploadSuccess extends FotoTrabajoState {
  final FotoTrabajoModel nuevaFoto;

  const FotoTrabajoUploadSuccess(this.nuevaFoto);
  
  @override
  List<Object> get props => [nuevaFoto];
}

/// Indica que una foto se está eliminando.
final class FotoTrabajoDeleting extends FotoTrabajoState {}

/// Indica que la foto se eliminó con éxito.
final class FotoTrabajoDeleteSuccess extends FotoTrabajoState {}

final class FotoTrabajoError extends FotoTrabajoState {
  final String message;

  const FotoTrabajoError(this.message);

  @override
  List<Object> get props => [message];
}