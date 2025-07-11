import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';
import 'package:tm1/domain/datasource/foto_solicitud_datasource.dart';

class FotoSolicitudDbDatasource implements FotoSolicitudDatasource{
  final _dioClient = DioClient();

  @override
  Future<List<FotoSolicitudModel>> uploadFotos(int solicitudId, List<String> fotosPaths) async {
    const endPoint = '/fotos-solicitud/'; 

    try {
      final response = await _dioClient.postWithFile(
        endPoint,
        solicitudId: solicitudId,
        fotosPaths: fotosPaths,
        istoken: true, 
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic responseData = response.data;

        // Verificamos si la respuesta del servidor es una Lista (para múltiples fotos)
        if (responseData is List) {
          return responseData.map((json) => 
            FotoSolicitudModel.fromJson(json as Map<String, dynamic>)
          ).toList();
        } 
        // Verificamos si la respuesta es un solo objeto/Mapa (para una sola foto)
        else if (responseData is Map) {
          final foto = FotoSolicitudModel.fromJson(responseData as Map<String, dynamic>);
          // Devolvemos una lista que contiene ese único objeto para que coincida
          // con el tipo de retorno del método Future<List<FotoSolicitudModel>>
          return [foto];
        } 
        // Si no es ni Lista ni Mapa, algo inesperado ocurrió
        else {
          throw Exception('Formato de respuesta inesperado del servidor.');
        }
        // --- FIN DE LA SOLUCIÓN ---
        // final List<dynamic> data = response.data;
        // return data.map((json) => FotoSolicitudModel.fromJson(json as Map<String, dynamic>)).toList();
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