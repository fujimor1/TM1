import 'dart:io';

import 'package:dio/dio.dart';
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
      final List<dynamic> tecnicosJson = response.data;
      List<TecnicoModel> allTecnicos = tecnicosJson.map((json) => TecnicoModel.fromJson(json)).toList();

      List<TecnicoModel> filteredTecnicos = allTecnicos.where((tecnico) {
        bool matchesCategory = true;
        if (categoryName != null && categoryName.isNotEmpty) {
          matchesCategory = tecnico.categorias.any((cat) => 
            cat.nombre != null && cat.nombre!.toLowerCase() == categoryName.toLowerCase()
          );
        }

        bool matchesDistrict = true;
        if (districtName != null && districtName.isNotEmpty) {
          matchesDistrict = tecnico.distritos.any((dist) => 
            dist.nombre != null && dist.nombre!.toLowerCase() == districtName.toLowerCase()
          );
        }
        return matchesCategory && matchesDistrict;
      }).toList();

      print('TecnicoDbDatasource: Loaded ${allTecnicos.length} total tecnicos. Filtered to ${filteredTecnicos.length} tecnicos for category: $categoryName, district: $districtName');
      
      return filteredTecnicos;

    } else {
      throw Exception('Error al obtener tecnicos: ${response.statusCode}');
    }
  }
  
  @override
  Future<TecnicoModel> updateTecnicoProfile(int tecnicoId, Map<String, dynamic> data) async {
    final endPoint = '/tecnicos/$tecnicoId/';

    final response = await _dioClient.patchWithFile(
      endPoint,
      data,
      istoken: true, 
    );

    if (response.statusCode == 200) {
      return TecnicoModel.fromJson(response.data);
    } else {
      throw Exception('Error al actualizar perfil de técnico: ${response.statusCode} - ${response.data}');
    }
  }

  @override
  Future<TecnicoModel> getTecnicoById(int tecnicoId) async {
    final endPoint = '/tecnicos/$tecnicoId/';
    try {
      final response = await _dioClient.getWithToken(endPoint);
      
      if (response.statusCode == 200) {
        return TecnicoModel.fromJson(response.data);
      } else {
        throw Exception('Error al obtener técnico por ID: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red al obtener técnico por ID: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener técnico por ID: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> createSubscriptionPreference(int tecnicoId) async {
    // El endpoint usa el ID del usuario, que es el mismo que el del técnico.
    final endPoint = '/usuarios/$tecnicoId/create-subscription-payment/';

    // Hacemos una petición POST. No necesita `data` según tu backend.
    final response = await _dioClient.post(endPoint, null, istoken: true);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Devuelve el mapa con los datos de la preferencia (ID y init_point).
      return response.data as Map<String, dynamic>;
    } else {
      final String errorMessage = response.data.toString();
      throw Exception('Failed to create Mercado Pago preference: ${response.statusCode} - $errorMessage');
    }
  }

}