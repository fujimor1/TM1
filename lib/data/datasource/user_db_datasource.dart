import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/user/user_model.dart';
import 'package:tm1/domain/datasource/user_datasource.dart';

class UserDbDatasource implements UserDatasource {
  final _dioClient = DioClient();

  @override
  Future<UserModel?> insertUser(UserModel user) async {
    const endPoint = '/usuarios/';
    final response = await _dioClient.post(
      endPoint,
      user.toJson(),
      istoken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // return true;
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    const endPoint = '/me/';
    final response = await _dioClient.getNoParams(endPoint, istoken: true);
    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } else if (response.statusCode == 401) {
      _dioClient.logout();
      return null;
    }
    return null;
  }
   
  @override
  Future<UserModel?> patchUser(Map<String, dynamic> user, int idUser) async {
    final endPoint = '/usuarios/$idUser/';
    // print('Token actual para PATCH: ${DioClient.token}');
    final response = await _dioClient.patch(endPoint, user, istoken: true);

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }
}
