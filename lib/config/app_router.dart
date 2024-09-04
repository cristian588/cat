import 'package:go_router/go_router.dart';
import '../presentation/screens/splash_screen.dart';
import '../presentation/screens/landing_screen.dart';
import '../presentation/screens/cat_detail_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: '/landing',
      builder: (context, state) => LandingScreen(),
    ),
    GoRoute(
      path: '/catDetail/:id',
      builder: (context, state) {
        final String catId = state.pathParameters['id']!;
        return CatDetailScreen(catId: catId);
      },
    ),
  ],
);
