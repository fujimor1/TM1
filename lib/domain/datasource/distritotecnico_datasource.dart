import 'package:tm1/data/model/distritotecnico/distritotecnico_model.dart';

abstract class DistritotecnicoDatasource {
  Future<DistritoTecnicoModel> postDistritoTecnico(Map<String, dynamic> data);
}