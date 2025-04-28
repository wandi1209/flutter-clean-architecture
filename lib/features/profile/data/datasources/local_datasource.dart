import '../models/profile_model.dart';
import 'package:hive/hive.dart';

abstract class ProfileLocalDatasource {
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileLocalDataSourceImplementation extends ProfileLocalDatasource {
  final HiveCollection hive;

  ProfileLocalDataSourceImplementation({required this.hive});

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    var box = Hive.box('profile_box');
    return box.get("getAllUser");
  }

  @override
  Future<ProfileModel> getUserById(int id) async {
    var box = Hive.box('profile_box');
    return box.get("getUserById");
  }
}
