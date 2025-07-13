import 'package:tm1/config/dio/dio_client.dart';
// import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/data/model/tecnicocategoria/tecnicocategoria_model.dart';
import 'package:tm1/domain/datasource/tecnicocategoria_datasource.dart';

class TecnicocategoriaDbDatasource implements TecnicocategoriaDatasource{
  final _dioClient = DioClient();

  @override
  Future<TecnicoCategoriaModel> insertTecnicoCategoria(Map<String, dynamic> tecnico) async{
    const endPoint = '/tecnicos-categorias/';
    final response = await _dioClient.post(
      endPoint,
      tecnico,
      istoken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
        return TecnicoCategoriaModel.fromJson(response.data);
    } else {
      throw Exception('Error al insertar técnico-categoria: ${response.statusCode}');
    }
  }

  @override
  Future<TecnicoCategoriaModel?> patchTecnicoCategoria(Map<String, dynamic> tecnicocategoria, int idTecnico) async {
    final endPoint = '/tecnicos-categorias/$idTecnico/';
    // print('Token actual para PATCH: ${DioClient.token}');
    final response = await _dioClient.patch(endPoint, tecnicocategoria, istoken: true);

    if (response.statusCode == 200) {
      return TecnicoCategoriaModel.fromJson(response.data as Map<String, dynamic>);
    }
    return null;
  }

  
}