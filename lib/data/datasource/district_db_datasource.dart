import 'package:tm1/config/dio/dio_client.dart';
import 'package:tm1/data/model/district/district_model.dart';
import 'package:tm1/domain/datasource/district_datasource.dart';

class DistrictDbDatasource implements DistrictDatasource{
  final _dioClient = DioClient();

  @override
  Future<List<DistrictModel>> getDistrict() async {
    const endPoint = '/distritos/';
    final response = await _dioClient.get(endPoint, null, istoken:true);
    if (response.statusCode == 200) {
      final listDistrict = (response.data as List)
          .map<DistrictModel>((json) => DistrictModel.fromJson(json))
          .toList();
      return listDistrict;
    } else {
      return [];
    }
  }

}