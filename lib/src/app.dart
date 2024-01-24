import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_view.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/folders_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_view.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

import 'features/content-manager/folder-details/folder_details_controller.dart';
import 'features/content-manager/folder-details/repository/file_repository.dart';

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
  late final GoRouter _router;

  @override
  void initState() {
    _router = _buildRouter(initialPath: widget.initialRoute);
    super.initState();
  }

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
          routerConfig: _router,
        ),
      ),
    );
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
            key: const ValueKey(LoginView.routeName),
            title: 'Login',
            child: LoginView(
              pageRouteObserver: pageRouteObserver,
            ),
          ),
          routes: [
            GoRoute(
              name: FoldersView.routeName,
              path: 'folders',
              pageBuilder: (_, __) => CupertinoPage(
                key: const ValueKey(FoldersView.routeName),
                title: 'Projects',
                child: ChangeNotifierProvider(
                  create: (_) => FoldersController(
                    Provider.of<FolderRepository>(context),
                  ),
                  child: const FoldersView(),
                ),
              ),
              redirect: (context, _) {
                final loginController =
                    Provider.of<LoginController>(context, listen: false);

                // redirect to login if the user tries to navigate to
                // authenticated content without being authenticated. This
                // affects all routes below this route.
                return !loginController.authenticated ? '/' : null;
              },
              routes: [
                GoRoute(
                  name: FoldersDetailsView.routeName,
                  path: ':id',
                  pageBuilder: (_, state) {
                    return CupertinoPage(
                      title: (state.extra as FolderModel?)?.name,
                      key: const ValueKey(FoldersDetailsView.routeName),
                      child: ChangeNotifierProvider(
                        create: (_) => FolderDetailsController(
                          FileRepository(),
                          Provider.of<FolderRepository>(context),
                          id: state.pathParameters['id'] as String,
                        ),
                        child: const FoldersDetailsView(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
