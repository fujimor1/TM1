import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';
import 'package:tm1/domain/datasource/foto_trabajo_datasource.dart';
import 'package:tm1/domain/repository/foto_trabajo_repository.dart';

class FotoTrabajoRepositoryImpl implements FotoTrabajoRepository{
  final FotoTrabajoDatasource datasource;

  FotoTrabajoRepositoryImpl(this.datasource);

  @override
  Future<List<FotoTrabajoModel>> getFotosByTecnicoAndCategoriaId(int tecnicoId, int categoriaId) {
    return datasource.getFotosByTecnicoAndCategoriaId(tecnicoId, categoriaId);
  }
  @override
  Future<FotoTrabajoModel> uploadFotoTrabajo({required int tecnicoId, required int categoriaId, required String fotoPath}) {
    return datasource.uploadFotoTrabajo(tecnicoId: tecnicoId, categoriaId: categoriaId, fotoPath: fotoPath);
  }
  @override
  Future<void> deleteFotoTrabajo(int fotoId) {
    return datasource.deleteFotoTrabajo(fotoId);
  }
}