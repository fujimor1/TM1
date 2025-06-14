import 'package:tm1/data/model/distritotecnico/distritotecnico_model.dart';

abstract class DistritotecnicoRepository {
  Future<DistritoTecnicoModel> postDistritoTecnico(Map<String, dynamic> data);
}