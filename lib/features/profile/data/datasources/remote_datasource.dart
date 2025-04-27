import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class ProfileRemoteDatasource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileRemoteDataSourceImplementation extends ProfileRemoteDatasource {
  final Dio dio;

  ProfileRemoteDataSourceImplementation({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: "https://reqres.in/api",
              headers: {"x-api-key": dotenv.env["API_KEY"]},
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          );

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
      throw EmptyException(message: "Data not found - Error 404");
    } else {
      throw GeneralException(message: "Cannot get data");
    }
  }
}
