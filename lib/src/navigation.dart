import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/file/file_details_view.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/folder_details_view.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folder-details/repository/file_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/folders_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/folders_view.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_model.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_view.dart';
import 'package:red_bull_flutter_case_study/src/sheet/sheet.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';

abstract class AppNavigatorInterface {
  RouterConfig<Object> get config;

  GlobalKey<NavigatorState> get navigatorKey;

  RouteObserver<PageRoute> get observer;

  void toFolders();

  void toFolderDetails({
    required String id,
    FolderModel? folder,
  });

  void toFile({
    required String folderId,
    required int id,
    FileModel? file,
  });
}

class AppNavigator extends InheritedWidget {
  const AppNavigator({
    required super.child,
    required this.implementation,
    super.key,
  });

  final AppNavigatorInterface implementation;

  static AppNavigatorInterface of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppNavigator>();
    assert(result != null, 'No AppNavigator found in context');
    return result!.implementation;
  }

  @override
  bool updateShouldNotify(AppNavigator oldWidget) =>
      implementation != oldWidget.implementation;
}

const _kLoginRouteName = 'login';
const _kFoldersRouteName = 'folders';
const _kFolderDetailsRouteName = 'folder-details';
const _kFileDetailsRouteName = 'file-details';

class GoRouterAppNavigator implements AppNavigatorInterface {
  GoRouterAppNavigator({
    this.initialPath,
    GlobalKey<NavigatorState>? navigatorKey,
    RouteObserver<PageRoute>? pageRouteObserver,
  })  : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>(),
        _pageRouteObserver = pageRouteObserver ?? RouteObserver<PageRoute>() {
    _initGoRouter();
  }

  final String? initialPath;
  final GlobalKey<NavigatorState> _navigatorKey;
  final RouteObserver<PageRoute> _pageRouteObserver;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  late final GoRouter _goRouter;

  @override
  RouterConfig<Object> get config => _goRouter;

  @override
  RouteObserver<PageRoute> get observer => _pageRouteObserver;

  void _initGoRouter() {
    _goRouter = GoRouter(
      navigatorKey: _navigatorKey,
      initialLocation: initialPath ?? '/',
      observers: [_pageRouteObserver],
      routes: [
        GoRoute(
          name: _kLoginRouteName,
          path: '/',
          pageBuilder: (_, __) => CupertinoPage(
            key: const ValueKey(_kLoginRouteName),
            title: 'Login',
            child: LoginView(
              pageRouteObserver: _pageRouteObserver,
            ),
          ),
          routes: [
            GoRoute(
              name: _kFoldersRouteName,
              path: 'folders',
              pageBuilder: (context, __) => CupertinoExtendedPage(
                key: const ValueKey(_kFoldersRouteName),
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
                  name: _kFolderDetailsRouteName,
                  path: ':folderId/files',
                  pageBuilder: (context, state) {
                    return CupertinoSheetPage(
                      backgroundColor: RbColors.of(context).primary,
                      key: const ValueKey(_kFolderDetailsRouteName),
                      showPreviousRoute: false,
                      child: ChangeNotifierProvider(
                        create: (_) => FolderDetailsController(
                          FileRepository(),
                          Provider.of<FolderRepository>(context),
                          id: state.pathParameters['folderId'] as String,
                        ),
                        child: const FolderDetailsView(),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: _kFileDetailsRouteName,
                      path: ':fileId',
                      pageBuilder: (_, state) {
                        // TODO: show file view
                        return const CupertinoSheetPage(
                            key: ValueKey(_kFileDetailsRouteName),
                            child: FileDetailsView());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  void toFolders() {
    _goRouter.goNamed(_kFoldersRouteName);
  }

  @override
  void toFolderDetails({
    required String id,
    FolderModel? folder,
  }) {
    _goRouter.goNamed(
      _kFolderDetailsRouteName,
      pathParameters: {'folderId': id},
      extra: folder,
    );
  }

  @override
  void toFile({
    required String folderId,
    required int id,
    FileModel? file,
  }) {
    _goRouter.goNamed(
      _kFileDetailsRouteName,
      pathParameters: {
        'folderId': folderId,
        'fileId': id.toString(),
      },
      extra: file,
    );
  }
}
