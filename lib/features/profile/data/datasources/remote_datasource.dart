import 'package:clean_architecture/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDatasource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileRemoteDataSourceImplementation extends ProfileRemoteDatasource {
  final dio = Dio();

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    final url = "https://reqres.in/api/users?page=$page";
    var response = await dio.get(url);

    final List data = response.data["data"];
    return ProfileModel.fromJsonList(data);
  }

  @override
  Future<ProfileModel> getUserById(int id) async {
    final url = "https://reqres.in/api/users/$id";
    var response = await dio.get(url);

    final data = response.data["data"];
    return ProfileModel.fromJson(data);
  }
}
