// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:tm1/data/datasource/user_db_datasource.dart';
// import 'package:tm1/data/model/user/user_model.dart';
// import 'package:tm1/data/repository/user_repository_impl.dart';   

// part 'register_state.dart';

// class RegisterCubit extends Cubit<RegisterState>{
//   final repository = UserRepositoryImpl(UserDbDatasource());

//   RegisterCubit() : super(RegisterInitial());

//   Future<void> insertUser(UserModel user) async {
//     emit(RegisterLoading());
//     try {
//       final success = await repository.insertUser(user);
//       if (success != null ) {
//         emit(RegisterLoaded(user));
//       } else {
//         emit(RegisterError());
//       }
//     } catch (e){
//       emit(RegisterError());
//     }
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/datasource/user_db_datasource.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/data/repository/user_repository_impl.dart';
import 'package:flutter/foundation.dart'; // Importar para debugPrint

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState>{
  final repository = UserRepositoryImpl(UserDbDatasource());

  RegisterCubit() : super(RegisterInitial());

  Future<void> insertUser(UserModel user) async {
    emit(RegisterLoading());
    try {
      final registeredUserWithId = await repository.insertUser(user); 

      if (registeredUserWithId != null) {
        debugPrint('Cubit va a emitir RegisterLoaded con ID: ${registeredUserWithId.id}');

        emit(RegisterLoaded(registeredUserWithId));
      } else {
        emit(RegisterError());
      }
    } catch (e){
      debugPrint('Error en RegisterCubit: $e');
      emit(RegisterError());
    }
  }
}