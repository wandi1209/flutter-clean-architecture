import '../../../../core/errors/exception.dart';
import '../models/profile_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDatasource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileRemoteDataSourceImplementation extends ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDataSourceImplementation(this.dio);

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    var response = await dio.get("/users?page=$page");

    if (response.statusCode == 200) {
      final List data = response.data["data"];
      if (data.isEmpty) {
        throw const EmptyException(message: "Error Empty Data");
      }
      return ProfileModel.fromJsonList(data);
    } else if (response.statusCode == 404) {
      throw const StatusCodeException(message: "Data not found - Error 404");
    } else {
      throw const GeneralException(message: "Cannot get data");
    }
  }

  @override
  Future<ProfileModel> getUserById(int id) async {
    var response = await dio.get("/users/$id");

    if (response.statusCode == 200) {
      final data = response.data["data"];
      return ProfileModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw const EmptyException(message: "Data not found - Error 404");
    } else {
      throw const GeneralException(message: "Cannot get data");
    }
  }
}
