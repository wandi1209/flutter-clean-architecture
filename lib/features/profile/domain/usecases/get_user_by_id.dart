import '../../../../core/errors/failure.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class GetUserById {
  final ProfileRepository profileRepository;

  GetUserById({required this.profileRepository});

  Future<Either<Failure, Profile>> execute(int id) async {
    return await profileRepository.getUserById(id);
  }
}
