part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoaded extends RegisterState {
  final UserModel userModel;

  const RegisterLoaded(this.userModel);
  @override
  List<Object> get props => [userModel];
}

final class RegisterLoading extends RegisterState {}

final class RegisterError extends RegisterState {}