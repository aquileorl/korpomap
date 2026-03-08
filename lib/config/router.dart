import 'package:go_router/go_router.dart';
import 'package:korpomap/screens/auth/login_screen.dart';
import 'package:korpomap/screens/auth/register_screen.dart';
import 'package:korpomap/services/auth_service.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state){
    final loggedIn = AuthService().currentUser != null;
    final goingToLogin = state.matchedLocation == '/login';
    final goingToRegister = state.matchedLocation == '/register';

    /// If you are not logged in and are not going to log in or register -> to login
    if (!loggedIn && !goingToLogin && !goingToRegister) return '/login';

    ///If you are logged in and go to login or register -> to the dashboard
    if (loggedIn && (goingToLogin || goingToRegister)) return '/dashboard';

    ///In any other case, do not redirect
    return null;
  },

  routes: [
    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // TODO: GoRoute  for /dashboard (Sprint 1, step 10)
  ],

);