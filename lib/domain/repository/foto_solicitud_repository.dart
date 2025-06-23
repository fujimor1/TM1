import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';

abstract class FotoSolicitudRepository {
  Future<List<FotoSolicitudModel>> uploadFotos(int solicitudId, List<String> fotosPaths);
}