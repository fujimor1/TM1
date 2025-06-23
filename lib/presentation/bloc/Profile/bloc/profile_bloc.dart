import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/data/repository/user_repository_impl.dart';
import 'package:tm1/domain/repository/user_repository.dart'; 
import 'package:tm1/data/datasource/user_db_datasource.dart'; 

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository _userRepository = UserRepositoryImpl(UserDbDatasource());

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileGetEvent>(_onProfileGetEvent);
    on<ProfilePatchEvent>(_onProfilePatchEvent);
  }

  Future<void> _onProfileGetEvent(
    ProfileGetEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await _userRepository.getCurrentUser();

      if (user == null) {
        emit(ProfileError());
      } else {
        emit(ProfileLoaded(user));
      }
    } catch (e) {
      print('Error en ProfileBloc: ${e.toString()}');
      emit(ProfileError());
    }
  }

  Future<void> _onProfilePatchEvent(
    ProfilePatchEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final user = await _userRepository.patchUser(event.user, event.idUser);

      if (user == null){
        emit(ProfileError());
      } else {
        emit(ProfileLoaded(user));
      }
    } catch (e) {
      print('Error en ProfileBloc (ProfilePatch): ${e.toString()}');
      emit(ProfileError());
    }
  }
}