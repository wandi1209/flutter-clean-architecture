import 'package:clean_architecture/features/profile/data/datasources/remote_datasource.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatasourceTest {}

void main() async {
  await dotenv.load(fileName: ".env");
  final ProfileRemoteDataSourceImplementation
  profileRemoteDataSourceImplementation =
      ProfileRemoteDataSourceImplementation();
  try {
    var response = await profileRemoteDataSourceImplementation.getUserById(533333);
    print(response.toJson());
  } catch (e) {
    print(e);
  }
}
