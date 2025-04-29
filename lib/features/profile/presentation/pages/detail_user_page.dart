import 'package:clean_architecture/injection.dart';

import '../../domain/entities/profile.dart';
import '../bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailUserPage extends StatelessWidget {
  final int userId;
  const DetailUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail User")),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: locator<ProfileBloc>()..add(ProfileEventGetDetailUser(userId)),
        builder: (context, state) {
          if (state is ProfileStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileStateError) {
            return Center(child: Text(state.message));
          } else if (state is ProfileStateLoadedDetailUser) {
            Profile user = state.detailUser;
            return Card(
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.profileUrl),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(color: Colors.blueGrey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("Empty Users"));
          }
        },
      ),
    );
  }
}
