import 'package:red_bull_flutter_case_study/src/features/login/repository/model/user_credentials_model.dart';

enum EmailValidationError { empty, invalid }

enum PasswordValidationError { empty, short, long, invalid }

/// An interface that exposes login validation functionalities.
abstract interface class LoginValidator {
  static const defaultMinPasswordLength = 8;
  static const defaultMaxPasswordLength = 255;

  EmailValidationError? validateEmail(String? value);

  PasswordValidationError? validatePassword(
    String? password, {
    int minLength,
    int maxLength,
  });
}

RegExp _emailRegex = RegExp(
    r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');

class LoginService implements LoginValidator {
  const LoginService();

  @override
  EmailValidationError? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return EmailValidationError.empty;
    } else if (!_emailRegex.hasMatch(value)) {
      return EmailValidationError.invalid;
    } else {
      return null;
    }
  }

  @override
  PasswordValidationError? validatePassword(
    String? password, {
    int minLength = LoginValidator.defaultMinPasswordLength,
    int maxLength = LoginValidator.defaultMaxPasswordLength,
  }) {
    if (password == null || password.isEmpty) {
      return PasswordValidationError.empty;
    } else if (password.length < minLength) {
      return PasswordValidationError.short;
    } else if (password.length > maxLength) {
      return PasswordValidationError.long;
    }

    final passwordRegex =
        _composePasswordRegex(minLength: minLength, maxLength: maxLength);

    if (!passwordRegex.hasMatch(password)) {
      return PasswordValidationError.invalid;
    } else {
      return null;
    }
  }

  bool areUserCredentialsValid(UserCredentialsModel credentials) {
    return validateEmail(credentials.email) == null &&
        validatePassword(credentials.password) == null;
  }

  RegExp _composePasswordRegex({
    required int minLength,
    required int maxLength,
  }) {
    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}|:;<>,.?/~`]).{"
      "$minLength,$maxLength"
      r'''}$''',
    );
  }
}
