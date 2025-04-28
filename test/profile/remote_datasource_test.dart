// INSTRUCTION FOR GENERATE COVERAGE

// >> flutter pub get
// >> dart run build_runner build --delete-conflicting-outputs
// >> flutter test --machine > tests.output

// TEST SEMUA FOLDER
// >> flutter test --coverage

// TEST SPESIFIK FOLDER
// >> flutter test test/profile --coverage

// GENERATE HTML DARI HASIL TEST COVERAGE
// >> genhtml coverage/lcov.info -o coverage/html --legend -t "Clean Architecture" --function-coverage

// OPEN HTML
// >> open coverage/html/index.html

// REMOVE
// >> lcov --remove coverage/lcov.info "core/errors/*" "features/profile/data/models/*" -o coverage/lcov.info

// Mock -> Class ProfileRemoteDatasource

import 'package:clean_architecture/core/errors/exception.dart';
import 'package:clean_architecture/features/profile/data/datasources/remote_datasource.dart';
import 'package:clean_architecture/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([MockSpec<ProfileRemoteDatasource>(), MockSpec<Dio>()])
import 'remote_datasource_test.mocks.dart';

void main() async {
  MockDio mockDio = MockDio();
  // Create mock object.
  var remoteDatasource = MockProfileRemoteDatasource();
  var remoteDatasourceImplementation = ProfileRemoteDataSourceImplementation(
    dio: mockDio,
  );

  const userId = 1;
  const page = 2;
  const urlGetAllUser = "/users?page=$page";
  const urlGetUserById = "/users/$userId";

  Map<String, dynamic> fakeDataJson = {
    "id": userId,
    "email": "user1@gmail.com",
    "first_name": "user",
    "last_name": "$userId",
    "avatar": "https://image.com/$userId",
  };

  ProfileModel fakeProfileModel = const ProfileModel(
    id: userId,
    email: "user1@gmail.com",
    firstName: "user",
    lastName: "$userId",
    avatar: "https://image.com/$userId",
  );

  group("DIO TESTING", () {
    test('TES PASSING DIO', () {
      // Verifikasi kalau dio yang di-passing ke constructor adalah mockDio
      expect(remoteDatasourceImplementation.dio, isA<Dio>());
    });

    test('TEST DIO REQUEST WITH CONFIGURATION', () async {
      // Pastikan dotenv.load() sudah dipanggil untuk memuat file .env
      await dotenv.load();

      // Stubbing Dio untuk memastikan request mengembalikan respons yang benar
      when(mockDio.get(any)).thenAnswer(
        (_) async => Response(
          data: {'key': 'value'},
          statusCode: 200,
          requestOptions: RequestOptions(
            path: "/users",
            baseUrl: "https://reqres.in/api",
            headers: {
              "x-api-key": "fake-api-key",
            }, // Header palsu untuk memastikan x-api-key ada
          ),
        ),
      );

      // Melakukan request dengan endpoint yang menguji konfigurasi Dio
      var response = await remoteDatasourceImplementation.dio.get("/users");

      // Verifikasi bahwa request menggunakan URL yang benar
      expect(response.requestOptions.baseUrl, "https://reqres.in/api");

      // Verifikasi bahwa header "x-api-key" digunakan dalam request
      expect(response.requestOptions.headers["x-api-key"], "fake-api-key");

      // Verifikasi bahwa status code yang diterima adalah 200
      expect(response.statusCode, 200);

      // Verifikasi bahwa data yang diterima sesuai dengan data palsu yang diatur
      expect(response.data, {'key': 'value'});
    });
  });

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
          await remoteDatasource.getUserById(userId);
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
          await remoteDatasource.getAllUser(page);
          fail("TIDAK MUNGKIN TERJADI");
          // Tidak Mungkin Terjadi Error
        } catch (e) {
          // Testing Untuk Kegagalan
          expect(e, isException);
        }
      });
    });
  });

  group("Profile Remote Datasource Implementation", () {
    group("getUserById()", () {
      test("BERHASIL (200)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetUserById)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetUserById),
            statusCode: 200,
            data: {"data": fakeDataJson},
          ),
        );

        try {
          var response = await remoteDatasourceImplementation.getUserById(
            userId,
          );
          expect(response, fakeProfileModel);
          // TES UNTUK KEBERHASILAN
        } catch (e) {
          // TIDAK MUNGKIN TERJADI
          fail(e.toString());
        }
      });
      test("GAGAL (404)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetUserById)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetUserById),
            statusCode: 404,
            data: {"data": fakeDataJson},
          ),
        );

        try {
          await remoteDatasourceImplementation.getUserById(userId);
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          expect(e, isA<EmptyException>());
        }
      });
      test("GAGAL (500)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetUserById)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetUserById),
            statusCode: 500,
            data: {"data": fakeDataJson},
          ),
        );

        try {
          await remoteDatasourceImplementation.getUserById(userId);
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          expect(e, isA<GeneralException>());
          // TES KEGAGALAN ERROR 500
        }
      });
    });
    group("getAllUser()", () {
      test("BERHASIL (200)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetAllUser)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetAllUser),
            statusCode: 200,
            data: {
              "data": [fakeDataJson],
            },
          ),
        );

        try {
          var response = await remoteDatasourceImplementation.getAllUser(page);
          expect(response, [fakeProfileModel]);
          // TES UNTUK KEBERHASILAN
        } catch (e) {
          // TIDAK MUNGKIN TERJADI
          fail(e.toString());
        }
      });
      test("GAGAL (EMPTY DATA)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetAllUser)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetAllUser),
            statusCode: 200,
            data: {"data": []},
          ),
        );

        try {
          await remoteDatasourceImplementation.getAllUser(page);
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } on EmptyException catch (e) {
          // TES KEGAGALAN EMPTY DATA
          expect(e, isA<EmptyException>());
        } on StatusCodeException {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        }
      });
      test("GAGAL (404)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetAllUser)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetAllUser),
            statusCode: 404,
            data: {
              "data": [fakeDataJson],
            },
          ),
        );

        try {
          await remoteDatasourceImplementation.getAllUser(page);
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } on EmptyException {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } on StatusCodeException catch (e) {
          // TES KEGAGALAN 404
          expect(e, isA<StatusCodeException>());
        } catch (e) {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        }
      });
      test("GAGAL (500)", () async {
        // Proses Stubbing
        when(mockDio.get(urlGetAllUser)).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: urlGetAllUser),
            statusCode: 500,
            data: {
              "data": [fakeDataJson],
            },
          ),
        );

        try {
          await remoteDatasourceImplementation.getAllUser(page);
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } on EmptyException {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } on StatusCodeException {
          // TIDAK MUNGKIN TERJADI
          fail("TIDAK MUNGKIN TERJADI");
        } catch (e) {
          // TES KEGAGALAN EMPTY DATA
          expect(e, isA<GeneralException>());
        }
      });
    });
  });
}
