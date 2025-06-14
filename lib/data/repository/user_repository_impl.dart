import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/domain/datasource/user_datasource.dart';
import 'package:tm1/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<UserModel?> insertUser(UserModel user) async {
    return await datasource.insertUser(user);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await datasource.getCurrentUser();
  }

  @override
  Future<UserModel?> patchUser(Map<String, dynamic> user, int idUser) async {
    return await datasource.patchUser(user, idUser);
  }
}
