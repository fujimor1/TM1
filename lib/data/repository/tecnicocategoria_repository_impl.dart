import 'package:tm1/data/model/tecnicocategoria/tecnicocategoria_model.dart';
import 'package:tm1/domain/datasource/tecnicocategoria_datasource.dart';
import 'package:tm1/domain/repository/tecnicocategoria_repository.dart';

class TecnicocategoriaRepositoryImpl implements TecnicocategoriaRepository{
  final TecnicocategoriaDatasource datasource;

  TecnicocategoriaRepositoryImpl(this.datasource);

  @override
  Future<TecnicoCategoriaModel> insertTecnicoCategoria(Map<String, dynamic> data) {
    return datasource.insertTecnicoCategoria(data);
  }
  
  @override
  Future<TecnicoCategoriaModel?> patchTecnicoCategoria(Map<String, dynamic> tecnicocategoria, int idTecnico) async{
    return await datasource.patchTecnicoCategoria(tecnicocategoria, idTecnico);
  }
}