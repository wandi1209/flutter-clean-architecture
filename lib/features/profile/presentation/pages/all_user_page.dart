import 'package:clean_architecture/injection.dart';

import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: locator<ProfileBloc>()..add(ProfileEventGetAllUsers(2)),
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileStateError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileStateLoadedAllUsers) {
            List<Profile> allUsers = state.allUsers;
            return ListView.builder(
              itemCount: allUsers.length,
              itemBuilder: (context, index) {
                Profile user = allUsers[index];
                return ListTile(
                  onTap: () {
                    context.pushNamed("detail_user", extra: user.id);
                  },
                  title: Text(user.fullName),
                );
              },
            );
          } else {
            return const Center(child: Text("Empty Users"));
          }
        },
      ),
    );
  }
}
