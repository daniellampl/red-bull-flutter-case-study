import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/login/service/login_service.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/model/user_credentials_model.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/user_credentials_repository.dart';

class LoginController with ChangeNotifier {
  LoginController(
    this._loginService,
    this._userCredentialsRepository,
  );

  final LoginService _loginService;
  final UserCredentialsRepository _userCredentialsRepository;

  UserCredentialsModel? _credentials;

  bool get authenticated => _credentials != null;

  Future<void> login({
    required String email,
    required String password,
  }) {
    if (authenticated) {
      throw Exception('User is already authenticated!');
    }

    final credentials = UserCredentialsModel(email: email, password: password);

    if (!_loginService.areUserCredentialsValid(credentials)) {
      throw ArgumentError('User credentials are not valid!');
    }

    return _userCredentialsRepository.save(credentials);
  }

  Future<void> logout() async {
    await _userCredentialsRepository.delete();
    _credentials = null;
  }

  Future<void> loadCredentials() async {
    _credentials = await _userCredentialsRepository.get();
    notifyListeners();
  }
}
