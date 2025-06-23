import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';
import 'package:tm1/domain/datasource/foto_solicitud_datasource.dart';

class FotoSolicitudDbDatasource implements FotoSolicitudDatasource{
  final _dioClient = DioClient();

  @override
  Future<List<FotoSolicitudModel>> uploadFotos(int solicitudId, List<String> fotosPaths) async {
    const endPoint = '/fotos-solicitud/upload/'; 

    try {
      final response = await _dioClient.postWithFile(
        endPoint,
        solicitudId: solicitudId,
        fotosPaths: fotosPaths,
        istoken: true, 
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((json) => FotoSolicitudModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        final String errorMessage = response.data.toString();
        throw Exception('Failed to upload fotos: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      print('Error en FotoSolicitudDbDatasource.uploadFotos: ${e.toString()}');
      throw Exception('Error al subir las fotos: ${e.toString()}');
    }
  }
}