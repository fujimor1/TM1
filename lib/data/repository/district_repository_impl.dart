import 'package:tm1/data/datasource/district_db_datasource.dart';
import 'package:tm1/data/model/district/district_model.dart';
import 'package:tm1/domain/repository/district_repository.dart';

class DistrictRepositoryImpl implements DistrictRepository{
  final DistrictDbDatasource datasource;

  DistrictRepositoryImpl(this.datasource);

  @override
  Future<List<DistrictModel>> getDistrict() async {
    return await datasource.getDistrict();
  }
}