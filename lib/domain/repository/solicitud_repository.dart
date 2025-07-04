import 'package:tm1/data/model/solicitud/solicitud_model.dart';

abstract class SolicitudRepository {
  Future<SolicitudModel> insertSolicitud(Map<String, dynamic> solicitud);
  Future<List<SolicitudModel>> getSolicitudesByClientId(int clientId);
  Future<List<SolicitudModel>> getSolicitudesByTecnicoId(int tecnicoId);
  Future<SolicitudModel> updateSolicitud(int solicitudId, Map<String, dynamic> data);
}