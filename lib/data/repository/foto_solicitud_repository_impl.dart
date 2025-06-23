import 'package:tm1/data/model/fotosolicitud/foto_solicitud_model.dart';
import 'package:tm1/domain/datasource/foto_solicitud_datasource.dart';
import 'package:tm1/domain/repository/foto_solicitud_repository.dart';

class FotoSolicitudRepositoryImpl implements FotoSolicitudRepository{
  final FotoSolicitudDatasource datasource;

  FotoSolicitudRepositoryImpl(this.datasource);

  @override
  Future<List<FotoSolicitudModel>> uploadFotos(int solicitudId, List<String> fotosPaths) {
    return datasource.uploadFotos(solicitudId, fotosPaths);
  }
}