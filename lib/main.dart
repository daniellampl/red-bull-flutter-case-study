import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:red_bull_flutter_case_study/src/features/content-manager/folders/repository/folder_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/login/login_controller.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/user_credentials_repository.dart';
import 'package:red_bull_flutter_case_study/src/features/login/service/impl/login_service.dart';
import 'package:red_bull_flutter_case_study/src/features/login/service/login_validator.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const loginService = LoginService();
  final loginController = LoginController(
    loginService,
    UserCredentialsRepository(),
  );

  // load user credentials from local storage
  await loginController.loadCredentials();

  runApp(
    MultiProvider(
      providers: [
        Provider<LoginValidator>.value(value: loginService),
        Provider<FolderRepository>.value(value: FolderRepository()),
        ChangeNotifierProvider.value(
          value: loginController,
          child: const RedBullCaseStudyApp(),
        ),
      ],
      child: RedBullCaseStudyApp(
        initialRoute: loginController.authenticated ? '/folders' : '/',
      ),
    ),
  );
}
