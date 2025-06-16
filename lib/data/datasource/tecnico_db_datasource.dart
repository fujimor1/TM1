import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/tecnico/tecnico_model.dart';
import 'package:tm1/domain/datasource/tecnico_datasource.dart';

class TecnicoDbDatasource implements TecnicoDatasource{
  final _dioClient = DioClient();

  @override
  Future<TecnicoModel> insertTecnico(Map<String, dynamic> tecnico) async{
    const endPoint = '/tecnicos/';
    final response = await _dioClient.post(
      endPoint,
      tecnico,
      istoken: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
        return TecnicoModel.fromJson(response.data);
    } else {
      throw Exception('Error al insertar técnico: ${response.statusCode}');
    }
  }
  
  @override
  Future<List<TecnicoModel>> getTecnicos({String? categoryName, String? districtName}) async {
    const endPoint = '/tecnicos/';

    final response = await _dioClient.get(endPoint, null, istoken: true);

    if (response.statusCode == 200) {
      //1`
      final List<dynamic> tecnicosJson = response.data;
      List<TecnicoModel> allTecnicos = tecnicosJson.map((json) => TecnicoModel.fromJson(json)).toList();

      // 2. Aplicar el filtrado en el cliente (Flutter)
      List<TecnicoModel> filteredTecnicos = allTecnicos.where((tecnico) {
        bool matchesCategory = true;
        // Si se especificó un nombre de categoría para filtrar
        if (categoryName != null && categoryName.isNotEmpty) {
          // Comprueba si alguna de las categorías del técnico coincide con el nombre
          matchesCategory = tecnico.categorias.any((cat) => 
            cat.nombre != null && cat.nombre!.toLowerCase() == categoryName.toLowerCase()
          );
        }

        bool matchesDistrict = true;
        // Si se especificó un nombre de distrito para filtrar
        if (districtName != null && districtName.isNotEmpty) {
          // Comprueba si alguno de los distritos del técnico coincide con el nombre
          matchesDistrict = tecnico.distritos.any((dist) => 
            dist.nombre != null && dist.nombre!.toLowerCase() == districtName.toLowerCase()
          );
        }
        
        // Un técnico coincide si cumple con los criterios de categoría Y de distrito
        return matchesCategory && matchesDistrict;
      }).toList();

      print('TecnicoDbDatasource: Loaded ${allTecnicos.length} total tecnicos. Filtered to ${filteredTecnicos.length} tecnicos for category: $categoryName, district: $districtName');
      
      return filteredTecnicos;

    } else {
      throw Exception('Error al obtener tecnicos: ${response.statusCode}');
    }
  } 
}