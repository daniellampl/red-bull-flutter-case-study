import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/content_manager_folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_view.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

class RedBullCaseStudyApp extends StatefulWidget {
  const RedBullCaseStudyApp({
    super.key,
    this.initialRoute,
  });

  final String? initialRoute;

  @override
  State<RedBullCaseStudyApp> createState() => _RedBullCaseStudyAppState();
}

class _RedBullCaseStudyAppState extends State<RedBullCaseStudyApp> {
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
                letterSpacing: -1.4,
              ),
            ),
          ),
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _buildRouter(
            initialPath: widget.initialRoute,
          ),
        ),
      ),
    );
  }
}

GoRouter _buildRouter({
  String? initialPath,
}) {
  final pageRouteObserver = RouteObserver<PageRoute>();

  return GoRouter(
    initialLocation: initialPath ?? '/',
    observers: [pageRouteObserver],
    routes: [
      GoRoute(
        name: LoginView.routeName,
        path: '/',
        pageBuilder: (_, __) => CupertinoPage(
          title: 'Content Manager',
          child: LoginView(
            pageRouteObserver: pageRouteObserver,
          ),
        ),
        routes: [
          GoRoute(
            name: ContentManagerFoldersView.routeName,
            path: 'folders',
            pageBuilder: (_, __) => const CupertinoPage(
              title: 'Projects',
              child: ContentManagerFoldersView(),
            ),
            redirect: (context, _) {
              final loginController =
                  Provider.of<LoginController>(context, listen: false);

              // redirect to login if the user tries to navigate to
              // authenticated content without being authenticated. This
              // affects all routes below this route.
              return !loginController.authenticated ? '/' : null;
            },
            builder: (_, __) => const ContentManagerFoldersView(),
          ),
        ],
      ),
    ],
  );
}
