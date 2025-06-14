import 'package:tm1/data/model/categories/categories_models.dart';

abstract class CategoriesDatasource {
  Future<List<CategoriesModel>> getCategories();
}