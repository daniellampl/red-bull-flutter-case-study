import 'package:flutter/foundation.dart';
import 'package:red_bull_flutter_case_study/src/features/login/service/impl/login_service.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/model/user_credentials_model.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/user_credentials_repository.dart';

class LoginController with ChangeNotifier {
  LoginController(
    this._loginService,
    this._userCredentialsRepository,
  ) {
    _userCredentialsRepository.credentials.addListener(notifyListeners);
  }

  final LoginService _loginService;
  final UserCredentialsRepository _userCredentialsRepository;

  bool get authenticated =>
      _userCredentialsRepository.credentials.value != null;

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

  Future<void> logout() {
    return _userCredentialsRepository.delete();
  }

  Future<void> loadCredentials() async {
    return _userCredentialsRepository.get();
  }

  @override
  void dispose() {
    _userCredentialsRepository.credentials.removeListener(notifyListeners);
    super.dispose();
  }
}
