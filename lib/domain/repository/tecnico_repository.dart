import 'package:tm1/data/model/tecnico/tecnico_model.dart';

abstract class TecnicoRepository {
  Future<TecnicoModel> insertTecnico(Map<String, dynamic> tecnico);
  Future<List<TecnicoModel>> getTecnicos();
}