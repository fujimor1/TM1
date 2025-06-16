import 'package:tm1/data/datasource/categories_db_datasource.dart';
import 'package:tm1/data/model/categories/categories_models.dart';
import 'package:tm1/domain/repository/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository{
  final CategoriesDbDatasource datasource;

  CategoriesRepositoryImpl(this.datasource);

  @override
  Future<List<CategoriesModel>> getCategories() async {
    return await datasource.getCategories();
  }
}