// Mock -> Class ProfileRemoteDatasource

import 'package:clean_architecture/features/profile/data/datasources/remote_datasource.dart';
import 'package:clean_architecture/features/profile/data/models/profile_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<ProfileRemoteDatasource>()])
import 'remote_datasource_test.mocks.dart';

void main() async {
  // Create mock object.
  var remoteDatasource = MockProfileRemoteDatasource();

  const userId = 1;
  const page = 2;

  ProfileModel fakeProfileModel = const ProfileModel(
    id: userId,
    email: "user1@gmail.com",
    firstName: "user",
    lastName: "$userId",
    avatar: "https://image.com/$userId",
  );

  group("Profile Remote Datasource", () {
    group("getUserById", () {
      test('BERHASIL', () async {
        // Proses Stubbing
        when(
          remoteDatasource.getUserById(userId),
        ).thenAnswer((_) async => fakeProfileModel);
        try {
          var response = await remoteDatasource.getUserById(userId);
          expect(response, fakeProfileModel);
          // Testing Untuk Keberhasilan
        } catch (e) {
          // Tidak Mungkin Terjadi
          fail("TIDAK MUNGKIN TERJADI ERROR");
        }
      });

      test('GAGAL', () async {
        // Proses Stubbing
        when(remoteDatasource.getUserById(userId)).thenThrow(Exception());
        try {
          var response = await remoteDatasource.getUserById(userId);
          fail("TIDAK MUNGKIN TERJADI");
          // Tidak Mungkin Terjadi Error
        } catch (e) {
          // Testing Untuk Kegagalan
          expect(e, isException);
        }
      });
    });

    group("getAllUser", () {
      test('BERHASIL', () async {
        // Proses Stubbing
        when(
          remoteDatasource.getAllUser(page),
        ).thenAnswer((_) async => [fakeProfileModel]);
        try {
          var response = await remoteDatasource.getAllUser(page);
          expect(response, [fakeProfileModel]);
          // Testing Untuk Keberhasilan
        } catch (e) {
          // Tidak Mungkin Terjadi
          fail("TIDAK MUNGKIN TERJADI ERROR");
        }
      });

      test('GAGAL', () async {
        // Proses Stubbing
        when(remoteDatasource.getAllUser(page)).thenThrow(Exception());
        try {
          var response = await remoteDatasource.getAllUser(page);
          fail("TIDAK MUNGKIN TERJADI");
          // Tidak Mungkin Terjadi Error
        } catch (e) {
          // Testing Untuk Kegagalan
          expect(e, isException);
        }
      });
    });
  });
}
