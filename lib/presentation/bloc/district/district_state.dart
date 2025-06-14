part of 'district_cubit.dart';

sealed class DistrictState extends Equatable{
  const DistrictState();

  @override
  List<Object> get props => [];
}

final class DistrictInitial extends DistrictState {}

final class DistrictLoading extends DistrictState {}

final class DistrictError extends DistrictState {}

final class DistrictLoaded extends DistrictState {
  final List<Map> district;
  const DistrictLoaded({required this.district});
  @override
  List<Object> get props => [district];
}