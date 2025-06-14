import 'package:tm1/data/model/district/district_model.dart';

abstract class DistrictRepository {
  Future<List<DistrictModel>> getDistrict();
}