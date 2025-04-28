import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/pages/all_user_page.dart';
import '../../features/profile/presentation/pages/detail_user_page.dart';

class AppRouter {
  get router => GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(
        path: "/",
        name: "all_users",
        pageBuilder:
            (context, state) => const NoTransitionPage(child: AllUserPage()),
        routes: [
          // sub routes
          GoRoute(
            path: "detail-user",
            name: "detail_user",
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: DetailUserPage(userId: state.extra as int),
                ),
          ),
        ],
      ),
    ],
  );
}
