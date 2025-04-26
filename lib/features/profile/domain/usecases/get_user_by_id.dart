import 'package:clean_architecture/features/profile/domain/entities/profile.dart';
import 'package:clean_architecture/features/profile/domain/repositories/profile_repository.dart';

class GetUserById {
  final ProfileRepository profileRepository;

  GetUserById({required this.profileRepository});

  Future<Profile> execute(int id) async {
    return await profileRepository.getUserById(id);
  }
}
