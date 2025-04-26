import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/features/profile/domain/entities/profile.dart';
import 'package:clean_architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUser {
  final ProfileRepository profileRepository;

  GetAllUser({required this.profileRepository});

  Future<Either<Failure, List<Profile>>> execute(int page) async {
    return await profileRepository.getAllUser(page);
  }
}
