import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/domain/datasource/tecnico_datasource.dart';

class TecnicoDbDatasource implements TecnicoDatasource{
  final _dioClient = DioClient();

  @override
  Future<TecnicoModel> insertTecnico(Map<String, dynamic> tecnico) async{
    const endPoint = '/tecnicos/';
    final response = await _dioClient.post(
      endPoint,
      tecnico,
      istoken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
        return TecnicoModel.fromJson(response.data);
    } else {
      throw Exception('Error al insertar técnico: ${response.statusCode}');
    }
  }
  
  @override
  Future<List<TecnicoModel>> getTecnicos() async {
    const endPoint = '/tecnicos/';
    final response = await _dioClient.get(endPoint, null, istoken: true);

    if (response == 200) {
      final List<dynamic> tecnicosJson = response.data;
      return tecnicosJson.map((json) => TecnicoModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener tecnicos: ${response.statusCode}');
    }
  } 
}