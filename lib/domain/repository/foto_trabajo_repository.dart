import 'package:tm1/data/model/fototrabajo/foto_trabajo_model.dart';

abstract class FotoTrabajoRepository {
  Future<List<FotoTrabajoModel>> getFotosByTecnicoAndCategoriaId(int tecnicoId, int categoriaId);
  Future<FotoTrabajoModel> uploadFotoTrabajo({required int tecnicoId, required int categoriaId, required String fotoPath});
  Future<void> deleteFotoTrabajo(int fotoId);
}
