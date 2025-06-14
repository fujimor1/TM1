part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileGetEvent extends ProfileEvent {
  @override
  List<Object> get props => [];
}

class ProfilePatchEvent extends ProfileEvent {
  final Map<String, dynamic> user;
  final int idUser;

  const ProfilePatchEvent(this.user, this.idUser);

  @override
  List<Object> get props => [user, idUser];
}