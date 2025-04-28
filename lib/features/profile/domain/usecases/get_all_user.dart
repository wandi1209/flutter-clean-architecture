import '../../../../core/errors/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllUser {
  final ProfileRepository profileRepository;

  GetAllUser({required this.profileRepository});

  Future<Either<Failure, List<Profile>>> execute(int page) async {
    return await profileRepository.getAllUser(page);
  }
}
