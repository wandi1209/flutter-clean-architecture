import '../../../../core/errors/failure.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/profile_model.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

class ProfileRepositoryImplementation extends ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;
  final ProfileLocalDatasource localDatasource;
  final Box box;

  ProfileRepositoryImplementation({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.box,
  });

  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<ProfileModel> hasil = await localDatasource.getAllUser(page);
        return Right(hasil);
      } else {
        List<ProfileModel> hasil = await remoteDatasource.getAllUser(page);
        box.put("getAllUser", hasil);
        return Right(hasil);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUserById(int id) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        ProfileModel hasil = await localDatasource.getUserById(id);
        return Right(hasil);
      } else {
        Profile hasil = await remoteDatasource.getUserById(id);
        box.put("getUserById", hasil);
        return Right(hasil);
      }
    } catch (e) {
      return Left(Failure());
    }
  }
}
