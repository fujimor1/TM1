import 'package:tm1/data/model/distritotecnico/distritotecnico_model.dart';
import 'package:tm1/domain/datasource/distritotecnico_datasource.dart';
import 'package:tm1/domain/repository/distritotecnico_repository.dart';

class DistritotecnicoRepositoryImpl implements DistritotecnicoRepository{
  final DistritotecnicoDatasource datasource;
  DistritotecnicoRepositoryImpl(this.datasource);

  @override
  Future<DistritoTecnicoModel> postDistritoTecnico(Map<String, dynamic> data) {
    return datasource.postDistritoTecnico(data);
  }
}