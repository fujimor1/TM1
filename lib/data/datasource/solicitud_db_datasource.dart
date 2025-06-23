import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/domain/datasource/solicitud_datasource.dart';

class SolicitudDbDatasource implements SolicitudDatasource {
  final _dioClient = DioClient();

  @override
  Future<SolicitudModel> insertSolicitud(Map<String, dynamic> solicitud) async {
    const endPoint = '/solicitudes/';
    final response = await _dioClient.post(endPoint, solicitud, istoken: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SolicitudModel.fromJson(response.data);
    } else {
      final String errorMessage = response.data.toString();
      throw Exception(
        'Failed to create solicitud: ${response.statusCode} - $errorMessage',
      );
    }
  }

  @override
  Future<List<SolicitudModel>> getSolicitudesByClientId(int clientId) async {
    final endPoint = '/solicitudes/';
    final response = await _dioClient.getWithParams(
      endPoint,
      queryParams: {'cliente_id': clientId},
      istoken: true,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => SolicitudModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      final String errorMessage = response.data.toString();
      throw Exception(
        'Failed to get solicitudes for client: ${response.statusCode} - $errorMessage',
      );
    }
  }

  @override
  Future<List<SolicitudModel>> getSolicitudesByTecnicoId(int tecnicoId) async {
    const endPoint = '/solicitudes/';
    final response = await _dioClient.getWithParams(
      endPoint,
      queryParams: {'tecnico_usuario_id': tecnicoId},
      istoken: true,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data
          .map((json) => SolicitudModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      final String errorMessage = response.data.toString();
      throw Exception(
        'Failed to get solicitudes for tecnico: ${response.statusCode} - $errorMessage',
      );
    }
  }

  @override
  Future<SolicitudModel> updateSolicitud(int solicitudId, Map<String, dynamic> data,) async {
    final endPoint = '/solicitudes/$solicitudId/';

    final response = await _dioClient.patch(endPoint, data, istoken: true);

    if (response.statusCode == 200) {
      return SolicitudModel.fromJson(response.data);
    } else {
      final String errorMessage = response.data.toString();
      throw Exception(
        'Failed to update solicitud: ${response.statusCode} - $errorMessage',
      );
    }
  }
}
