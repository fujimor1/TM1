part of 'categories_cubit.dart';

sealed class CategoriesState extends Equatable{
  const CategoriesState();

  @override
  List<Object> get props => [];
}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoading extends CategoriesState {}

final class CategoriesError extends CategoriesState {}

final class CategoriesLoaded extends CategoriesState {
  final List<Map> categories;
  const CategoriesLoaded({required this.categories});
  @override
  List<Object> get props => [categories];
}