import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';

import 'features/profile/data/datasources/local_datasource.dart';
import 'features/profile/data/datasources/remote_datasource.dart';
import 'features/profile/data/models/profile_model.dart';
import 'features/profile/data/repositories/profile_repository_implementation.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_all_user.dart';
import 'features/profile/domain/usecases/get_user_by_id.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

var locator = GetIt.instance;

Future<void> init() async {
  /// GENERAL DEPENDENCIES
  // HIVE
  Hive.registerAdapter(ProfileModelAdapter());
  var box = await Hive.openBox("profile_box");
  final Dio dio = Dio(
            BaseOptions(
              baseUrl: "https://reqres.in/api",
              headers: {"x-api-key": dotenv.env["API_KEY"]},
              validateStatus: (status) {
                return status! < 500;
              },
            ),
          );

  locator.registerLazySingleton(() => box);
  locator.registerLazySingleton(() => dio);

  /// FEATURE - PROFILE
  // BLOC
  locator.registerFactory(
    () => ProfileBloc(getAllUser: locator(), getUserById: locator()),
  );

  // USECASE
  locator.registerLazySingleton(
    () => GetAllUser(profileRepository: locator()),
  );
  locator.registerLazySingleton(
    () => GetUserById(profileRepository: locator()),
  );

  // REPOSITORY
  locator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImplementation(
      remoteDatasource: locator(),
      localDatasource: locator(),
      box: locator(),
    ),
  );

  // DATASOURCE
  locator.registerLazySingleton<ProfileLocalDatasource>(
    () => ProfileLocalDataSourceImplementation(box: locator()),
  );
  locator.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDataSourceImplementation(dio),
  );
}
