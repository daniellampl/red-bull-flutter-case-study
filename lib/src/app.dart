import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_folder_view.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_view.dart';

import 'localization/localization.dart';

class RedBullCaseStudyApp extends StatelessWidget {
  const RedBullCaseStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: LoginView.routeName,
          path: '/',
          builder: (_, __) => const LoginView(),
          routes: [
            GoRoute(
              name: ContentManagerFolderView.routeName,
              path: 'folders',
              builder: (_, __) => const ContentManagerFolderView(),
            ),
          ],
        ),
      ],
    );

    return CupertinoApp.router(
      restorationScopeId: 'app',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: const CupertinoThemeData(),
      routerConfig: router,
    );
  }
}
