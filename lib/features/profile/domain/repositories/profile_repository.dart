import 'package:clean_architecture/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<List<Profile>> getAllUser(int page);
  Future<Profile> getUserById(int id);
}
