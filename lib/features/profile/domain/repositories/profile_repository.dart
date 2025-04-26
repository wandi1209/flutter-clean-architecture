import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/features/profile/domain/entities/profile.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, List<Profile>>> getAllUser(int page);
  Future<Either<Failure, Profile>> getUserById(int id);
}
