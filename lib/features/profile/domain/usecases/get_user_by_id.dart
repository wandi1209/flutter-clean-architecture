import 'package:clean_architecture/core/errors/failure.dart';
import 'package:clean_architecture/features/profile/domain/entities/profile.dart';
import 'package:clean_architecture/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserById {
  final ProfileRepository profileRepository;

  GetUserById({required this.profileRepository});

  Future<Either<Failure, Profile>> execute(int id) async {
    return await profileRepository.getUserById(id);
  }
}
