// lib/features/auth/presentation/cubit/login_state.dart
part of 'login_cubit.dart'; // Importante: indica que es parte de login_cubit.dart

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {}