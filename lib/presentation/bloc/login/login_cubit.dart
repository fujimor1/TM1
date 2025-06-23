// lib/features/auth/presentation/cubit/login_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/config/dio/dio_client.dart';

part 'login_state.dart'; 

class LoginCubit extends Cubit<LoginState> {
  final DioClient dioClient;

  LoginCubit(this.dioClient) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());

    try {
      final bool success = await dioClient.login(username, password);

      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginError());
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error de API en LoginCubit: Status ${e.response?.statusCode}, Data: ${e.response?.data}');
      } else {
        print('Error de red/desconocido en LoginCubit: ${e.message}');
      }
      emit(LoginError());
    } catch (e) {
      print('Error inesperado en LoginCubit: ${e.toString()}');
      emit(LoginError());
    }
  }

  void logout() {
    dioClient.logout();
    emit(LoginInitial());
  }
}