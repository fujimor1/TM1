import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/categories/categories_models.dart';
import 'package:tm1/domain/datasource/categories_datasource.dart';

class CategoriesDbDatasource implements CategoriesDatasource{
  final _dioClient = DioClient();

  @override
  Future<List<CategoriesModel>> getCategories() async {
    const endPoint = '/categorias/';
    final response = await _dioClient.get(endPoint, null, istoken:true);
    if (response.statusCode == 200) {
      final listCategories = (response.data as List)
          .map<CategoriesModel>((json) => CategoriesModel.fromJson(json))
          .toList();
      return listCategories;
    } else {
      return [];
    } 
  }
}