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

class LoadTecnicosByCategoryAndDistrict extends TecnicoEvent {
  final String categoryName;
  final String? districtName;

  const LoadTecnicosByCategoryAndDistrict({required this.categoryName, this.districtName});

  @override
  List<Object> get props => [categoryName, districtName ?? ''];
}

class UpdateTecnicoProfileEvent extends TecnicoEvent {
  final int tecnicoId;
  final Map<String, dynamic> data;

  const UpdateTecnicoProfileEvent(this.tecnicoId, this.data);

  @override
  List<Object> get props => [tecnicoId, data];
}

class GetTecnicoByIdEvent extends TecnicoEvent {
  final int tecnicoId;

  const GetTecnicoByIdEvent(this.tecnicoId);

  @override
  List<Object> get props => [tecnicoId];
}

class PatchTecnicoCategoriaEvent extends TecnicoEvent {
  final Map<String, dynamic> tecnicocategoriaData;
  final int idTecnicoCategoria;
  final int tecnicoPrincipalId;

  const PatchTecnicoCategoriaEvent({required this.tecnicocategoriaData, required this.idTecnicoCategoria, required this.tecnicoPrincipalId});

  

  @override
  List<Object> get props => [tecnicocategoriaData, idTecnicoCategoria, tecnicoPrincipalId];
}