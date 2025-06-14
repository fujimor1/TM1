// lib/features/auth/presentation/cubit/login_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/config/dio/dio_client.dart';

part 'login_state.dart'; // Asegúrate de que esta línea esté presente y correcta

class LoginCubit extends Cubit<LoginState> {
  final DioClient dioClient;

  LoginCubit(this.dioClient) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading()); // Emite el estado de carga

    try {
      final bool success = await dioClient.login(username, password);

      if (success) {
        emit(LoginSuccess()); // Éxito, sin argumentos
      } else {
        // Fallo en la autenticación, sin argumentos
        emit(LoginError());
      }
    } on DioException catch (e) {
      // Aunque manejes el error aquí, ya no pasas el mensaje al estado
      // Puedes imprimir para depuración, pero el estado de error será genérico
      if (e.response != null) {
        print('Error de API en LoginCubit: Status ${e.response?.statusCode}, Data: ${e.response?.data}');
      } else {
        print('Error de red/desconocido en LoginCubit: ${e.message}');
      }
      emit(LoginError()); // Error de conexión o inesperado, sin argumentos
    } catch (e) {
      print('Error inesperado en LoginCubit: ${e.toString()}');
      emit(LoginError()); // Cualquier otro error, sin argumentos
    }
  }

  void logout() {
    dioClient.logout();
    emit(LoginInitial()); // Vuelve al estado inicial
  }
}