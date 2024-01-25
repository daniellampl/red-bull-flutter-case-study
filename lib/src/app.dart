import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:red_bull_flutter_case_study/src/localization/localization.dart';
import 'package:red_bull_flutter_case_study/src/navigation.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_colors.dart';
import 'package:red_bull_flutter_case_study/src/widgets/rb_typography.dart';

class RedBullCaseStudyApp extends StatelessWidget {
  const RedBullCaseStudyApp({
    super.key,
    this.initialRoute,
  });

  final String? initialRoute;

  @override
  Widget build(BuildContext context) {
    return RbColors(
      child: _App(
        initialPath: initialRoute,
      ),
    );
  }
}

class _App extends StatefulWidget {
  const _App({
    required this.initialPath,
  });

  final String? initialPath;

  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  late final AppNavigatorInterface _appNavigator;

  @override
  void initState() {
    _appNavigator = GoRouterAppNavigator(
      initialPath: widget.initialPath,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppNavigator(
      implementation: _appNavigator,
      child: CupertinoApp.router(
        restorationScopeId: 'app',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // place AppNavigator below the app so we can access the localizations
        // inside the router.
        builder: (_, child) => AppNavigator(
          implementation: _appNavigator,
          child: child!,
        ),
        // uses 'SF Pro' by default
        theme: CupertinoThemeData(
          barBackgroundColor: RbColors.of(context).background,
          textTheme: CupertinoTextThemeData(
            // the default letter spacing seems not correct
            // see also: https://github.com/flutter/flutter/issues/22572
            navLargeTitleTextStyle: titleBigOf(context),
          ),
        ),
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: _appNavigator.config,
      ),
    );
  }
}
