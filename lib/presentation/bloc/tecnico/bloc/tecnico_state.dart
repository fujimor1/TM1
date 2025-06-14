part of 'tecnico_bloc.dart';

sealed class TecnicoState extends Equatable {
  const TecnicoState();
  
  @override
  List<Object> get props => [];
}

final class TecnicoInitial extends TecnicoState {}
final class TecnicoLoading extends TecnicoState {}
final class TecnicoLoaded extends TecnicoState {
  final TecnicoModel tecnico;

  const TecnicoLoaded(this.tecnico);

  @override
  List<Object> get props => [tecnico];
}

final class TecnicosListLoaded extends TecnicoState {
  final List<TecnicoModel> tecnicos;

  const TecnicosListLoaded(this.tecnicos);

  @override
  List<Object> get props => [tecnicos];
}
final class TecnicoError extends TecnicoState {}
