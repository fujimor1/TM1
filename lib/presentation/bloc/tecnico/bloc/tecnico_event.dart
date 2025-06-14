part of 'tecnico_bloc.dart';

sealed class TecnicoEvent extends Equatable {
  const TecnicoEvent();

  @override
  List<Object> get props => [];
}

class InsertTecnicoEvent extends TecnicoEvent {
  final int usuarioId;
  final List<int> categoryIds;
  final List<int> districtIds;


  const InsertTecnicoEvent(this.usuarioId, this.categoryIds, this.districtIds);
  @override
  List<Object> get props => [usuarioId, categoryIds, districtIds];
}

class LoadTecnicosEvent extends TecnicoEvent {
  const LoadTecnicosEvent();

  @override
  List<Object> get props => [];
}
