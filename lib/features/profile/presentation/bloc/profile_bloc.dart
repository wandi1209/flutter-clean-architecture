import 'package:bloc/bloc.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_all_user.dart';
import '../../domain/usecases/get_user_by_id.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetAllUser getAllUser;
  final GetUserById getUserById;

  ProfileBloc({required this.getAllUser, required this.getUserById})
    : super(ProfileStateEmpty()) {
    on<ProfileEventGetAllUsers>((event, emit) async {
      emit(ProfileStateLoading());
      Either<Failure, List<Profile>> resultGetAllUser = await getAllUser
          .execute(event.page);
      resultGetAllUser.fold(
        (leftResultGetAllUsers) {
          emit(ProfileStateError("Cannot Get All Users"));
        },
        (rightResultGetAllUsers) {
          emit(ProfileStateLoadedAllUsers(rightResultGetAllUsers));
        },
      );
    });
    on<ProfileEventGetDetailUser>((event, emit) async {
      Either<Failure, Profile> resultGetUserById = await getUserById.execute(
        event.userId,
      );
      resultGetUserById.fold(
        (leftResultGetUserById) {
          emit(ProfileStateError("Cannot Get Detail User"));
        },
        (rightResultGetUserById) {
          emit(ProfileStateLoadedDetailUser(rightResultGetUserById));
        },
      );
    });
  }
}
