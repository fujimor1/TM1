import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/domain/datasource/tecnico_datasource.dart';
import 'package:tm1/domain/repository/tecnico_repository.dart';

class TecnicoRepositoryImpl implements TecnicoRepository{
  final TecnicoDatasource datasource;

  TecnicoRepositoryImpl(this.datasource);

  @override
  Future<TecnicoModel> insertTecnico(Map<String, dynamic> tecnico) async{
    return await datasource.insertTecnico(tecnico);
  }
  
  @override
  Future<List<TecnicoModel>> getTecnicos({String? categoryName, String? districtName}) async {
    return await datasource.getTecnicos(categoryName: categoryName, districtName: districtName);
  }
}