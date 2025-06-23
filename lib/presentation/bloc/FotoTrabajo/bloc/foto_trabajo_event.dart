part of 'foto_trabajo_bloc.dart';

sealed class FotoTrabajoEvent extends Equatable {
  const FotoTrabajoEvent();

  @override
  List<Object> get props => [];
}

class GetFotosByTecnicoAndCategoriaEvent extends FotoTrabajoEvent {
  final int tecnicoId;
  final int categoriaId;

  const GetFotosByTecnicoAndCategoriaEvent({
    required this.tecnicoId,
    required this.categoriaId,
  });

  @override
  List<Object> get props => [tecnicoId, categoriaId];
}

class UploadFotoTrabajoEvent extends FotoTrabajoEvent {
  final int tecnicoId;
  final int categoriaId;
  final String fotoPath;

  const UploadFotoTrabajoEvent({
    required this.tecnicoId,
    required this.categoriaId,
    required this.fotoPath,
  });

  @override
  List<Object> get props => [tecnicoId, categoriaId, fotoPath];
}

class DeleteFotoTrabajoEvent extends FotoTrabajoEvent {
  final int fotoId;
  final int tecnicoId;   // Necesario para refrescar la lista
  final int categoriaId; // Necesario para refrescar la lista

  const DeleteFotoTrabajoEvent({
    required this.fotoId,
    required this.tecnicoId,
    required this.categoriaId,
  });

  @override
  List<Object> get props => [fotoId, tecnicoId, categoriaId];
}