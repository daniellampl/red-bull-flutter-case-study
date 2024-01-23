import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_view.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: LoginView.routeName,
      path: '/',
      pageBuilder: (_, __) => const CupertinoPage(
        title: 'Content Manager',
        child: LoginView(),
      ),
      routes: [
        GoRoute(
          name: ContentManagerFoldersView.routeName,
          path: 'folders',
          pageBuilder: (_, __) => const CupertinoPage(
            title: 'Projects',
            child: ContentManagerFoldersView(),
          ),
          builder: (_, __) => const ContentManagerFoldersView(),
        ),
      ],
    ),
  ],
);

class RedBullCaseStudyApp extends StatelessWidget {
  const RedBullCaseStudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RbColors(
      child: Builder(
        builder: (context) => CupertinoApp.router(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // uses 'SF Pro' by default
          theme: CupertinoThemeData(
            barBackgroundColor: RbColors.of(context).background,
            textTheme: CupertinoTextThemeData(
              // the default letter spacing seems not correct
              // see also: https://github.com/flutter/flutter/issues/22572
              navLargeTitleTextStyle: TextStyle(
                color: RbColors.of(context).labelPrimary,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                height: 1.2,
                // letterSpacing: -1.4,
              ),
            ),
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        ),
      ),
    );
  }
}
