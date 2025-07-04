import 'package:tm1/data/model/tecnicocategoria/tecnicocategoria_model.dart';

abstract class TecnicocategoriaDatasource {
  Future<TecnicoCategoriaModel> insertTecnicoCategoria(Map<String, dynamic> data);
  Future<TecnicoCategoriaModel?> patchTecnicoCategoria(Map<String,dynamic> tecnicocategoria, int idTecnico);
}