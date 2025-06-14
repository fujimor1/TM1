import 'package:tm1/data/model/categories/categories_models.dart';

abstract class CategoriesRepository {
  Future<List<CategoriesModel>> getCategories();
}