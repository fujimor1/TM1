import 'package:tm1/data/model/tecnico/tecnico_model.dart';

abstract class TecnicoDatasource {
  Future<TecnicoModel> insertTecnico(Map<String, dynamic> tecnico);
  Future<List<TecnicoModel>> getTecnicos({String? categoryName, String? districtName});
  Future<TecnicoModel> updateTecnicoProfile(int tecnicoId, Map<String, dynamic> data);
  Future<TecnicoModel> getTecnicoById(int tecnicoId);
  Future<Map<String, dynamic>> createSubscriptionPreference(int tecnicoId);
}