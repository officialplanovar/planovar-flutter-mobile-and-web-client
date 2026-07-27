import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api/token_store.dart';
import 'core/router/app_routes.dart';
import 'core/router/router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/utils/deep_link_auth.dart';
import 'core/utils/oauth_redirect.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Google sign-in return trip. Web: the token relay appends the bearer token
  // to the app URL — capture it before boot, then scrub it from the address
  // bar. Native: the relay redirects to the planovar:// deep link — capture the
  // cold-start token here (warm links are handled in _RouterAppState).
  if (kIsWeb) {
    final relayToken = Uri.base.queryParameters['planovar_token'];
    if (relayToken != null && relayToken.isNotEmpty) {
      await TokenStore().save(relayToken);
      clearOAuthParams();
    }
  } else {
    final token = await DeepLinkAuth().initialToken();
    if (token != null) await TokenStore().save(token);
  }
  final themeCubit = ThemeCubit();
  await themeCubit.load();
  runApp(PlanovarApp(themeCubit: themeCubit));
}

class PlanovarApp extends StatelessWidget {
  const PlanovarApp({super.key, required this.themeCubit});
  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (_) => AuthBloc()),
      ],
      child: const _RouterApp(),
    );
  }
}

class _RouterApp extends StatefulWidget {
  const _RouterApp();

  @override
  State<_RouterApp> createState() => _RouterAppState();
}

class _RouterAppState extends State<_RouterApp> {
  late final _router = createRouter();

  @override
  void initState() {
    super.initState();
    // Warm-start OAuth deep links (app already running): store the relayed
    // token and bounce through splash so the session check re-runs and lands
    // the user on the authenticated home.
    if (!kIsWeb) {
      DeepLinkAuth().listen((token) async {
        await TokenStore().save(token);
        if (mounted) _router.go(AppRoutes.splash);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Planovar',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          routerConfig: _router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
