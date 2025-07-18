import 'package:tm1/data/model/solicitud/solicitud_model.dart';
import 'package:tm1/domain/datasource/solicitud_datasource.dart';
import 'package:tm1/domain/repository/solicitud_repository.dart';

class SolicitudRepositoryImpl implements SolicitudRepository{
  final SolicitudDatasource datasource;

  SolicitudRepositoryImpl(this.datasource);

  @override
  Future<SolicitudModel> insertSolicitud(Map<String, dynamic> solicitud) {
    return datasource.insertSolicitud(solicitud);
  }
  @override
  Future<List<SolicitudModel>> getSolicitudesByClientId(int clientId) {
    return datasource.getSolicitudesByClientId(clientId);
  }
  @override
  Future<List<SolicitudModel>> getSolicitudesByTecnicoId(int tecnicoId) {
    return datasource.getSolicitudesByTecnicoId(tecnicoId);
  }
  @override
  Future<SolicitudModel> updateSolicitud(int solicitudId, Map<String, dynamic> data) {
    return datasource.updateSolicitud(solicitudId, data);
  }
}