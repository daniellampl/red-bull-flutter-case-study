enum EmailValidationError { empty, invalid }

enum PasswordValidationError { empty, short, long, invalid }

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
