import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:am_i_cooked/pages/profile_page.dart';
import 'package:am_i_cooked/pages/recipes_page.dart';
import 'package:am_i_cooked/pages/search_page.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:am_i_cooked/theme/dark_theme_data.dart';
import 'package:am_i_cooked/theme/light_theme_data.dart';
import 'package:am_i_cooked/utils/auth_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  final authService = AuthService(dio);
  await authService.bootstrapSession();

  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => AuthLayout()),
      GoRoute(
        path: '/recipe/:id',
        builder: (context, state) {
          final idRecipe = state.pathParameters['id']!;
          return RecipesPage(heroTag: idRecipe, id: int.parse(idRecipe));
        },
      ),
      GoRoute(
        path: '/profile/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProfilePage(userId: int.parse(id));
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return ProfilePage();
        },
      ),
      GoRoute(path: '/search', builder: (context, state) => SearchPage()),
      GoRoute(path: '/new', builder: (context, state) => const Scaffold(body: Center(child: Text('New Recipe Page')))),
      GoRoute(path: '/favorites', builder: (context, state) => FavoritesPage()),
    ],
    initialLocation: '/',
  );
  runApp(ProviderScope(child: AmICookedApp(router: router)));
}

class AmICookedApp extends StatelessWidget {
  final GoRouter? router;

  const AmICookedApp({super.key, this.router});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: lightTheme,
      dark: darkTheme,
      builder: (light, dark) => MaterialApp.router(
        title: 'Am I Cooked?',
        theme: light,
        darkTheme: dark,
        routerConfig: router,
      ),
    );
  }
}
