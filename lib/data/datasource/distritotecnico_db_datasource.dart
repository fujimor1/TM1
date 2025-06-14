import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/distritotecnico/distritotecnico_model.dart';
import 'package:tm1/domain/datasource/distritotecnico_datasource.dart';

class DistritotecnicoDbDatasource implements DistritotecnicoDatasource {
  final _dioClient = DioClient();

  @override
  Future<DistritoTecnicoModel> postDistritoTecnico(Map<String, dynamic> data,) async{
    const endPoint = '/distritos-tecnicos/';
    final response = await _dioClient.post(endPoint, data, istoken: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DistritoTecnicoModel.fromJson(response.data);
    } else {
      throw Exception('Error al insertar técnico: ${response.statusCode}');
    }
  }
}
