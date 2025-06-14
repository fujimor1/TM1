import 'package:tm1/data/model/user/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> insertUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<UserModel?> patchUser (Map<String, dynamic> user, int idUser);
}