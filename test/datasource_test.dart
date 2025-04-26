import 'package:clean_architecture/features/profile/data/datasources/remote_datasource.dart';

class DatasourceTest {}

void main() async {
  final ProfileRemoteDataSourceImplementation
  profileRemoteDataSourceImplementation =
      ProfileRemoteDataSourceImplementation();
  var response = await profileRemoteDataSourceImplementation.getAllUser(2);
  print(response);
}
