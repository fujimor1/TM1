import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';
import 'package:tm1/domain/datasource/foto_trabajo_datasource.dart';

class FotoTrabajoDbDatasource implements FotoTrabajoDatasource{
  final _dioClient = DioClient();

  @override
  Future<List<FotoTrabajoModel>> getFotosByTecnicoAndCategoriaId(int tecnicoId, int categoriaId) async {
    const endPoint = '/fotos-trabajos/';

    final queryParams = {
      'tecnico_id': tecnicoId,
      'categoria_id': categoriaId,
    };

    final response = await _dioClient.getWithParams(
      endPoint,
      queryParams: queryParams,
      istoken: true, 
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) =>
              FotoTrabajoModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      final String errorMessage = response.data.toString();
      throw Exception(
          'Failed to get fotos de trabajo: ${response.statusCode} - $errorMessage');
    }
  }
  
  @override
  Future<FotoTrabajoModel> uploadFotoTrabajo({
    required int tecnicoId,
    required int categoriaId,
    required String fotoPath,
  }) async {
    const endPoint = '/fotos-trabajos/';

    final fields = {
      'tecnico': tecnicoId.toString(),
      'categoria': categoriaId.toString(),
    };
    final files = [
      MapEntry('url_foto', fotoPath),
    ];
    final response = await _dioClient.postMultipart(
      endPoint,
      fields: fields,
      files: files,
      istoken: true,
    );
    
    if (response.statusCode == 201) {
      return FotoTrabajoModel.fromJson(response.data);
    } else {
      final String errorMessage = response.data.toString();
      throw Exception('Failed to upload foto de trabajo: ${response.statusCode} - $errorMessage');
    }
  }

  @override
  Future<void> deleteFotoTrabajo(int fotoId) async {
    final endPoint = '/fotos-trabajos/$fotoId/';

    final response = await _dioClient.delete(endPoint, istoken: true);

    if (response.statusCode != 204) {
      final String errorMessage = response.data.toString();
      throw Exception('Failed to delete foto de trabajo: ${response.statusCode} - $errorMessage');
    }
  }
}