import 'package:clean_architecture/features/profile/domain/entities/profile.dart';
import 'package:clean_architecture/features/profile/domain/repositories/profile_repository.dart';

class GetAllUser {
  final ProfileRepository profileRepository;

  GetAllUser({required this.profileRepository});

  Future<List<Profile>> execute(int page) async {
    return await profileRepository.getAllUser(page);
  }
}
