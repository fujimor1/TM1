import 'package:tm1/data/model/district/district_model.dart';

abstract class DistrictDatasource {
  Future<List<DistrictModel>> getDistrict();
}