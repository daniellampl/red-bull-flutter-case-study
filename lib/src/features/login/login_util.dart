import 'package:red_bull_flutter_case_study/src/localization/localization.dart';

RegExp _emailRegex = RegExp(
    r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');

const _kDefaultMinLength = 8;
const _kDefaultMaxLength = 255;

class LoginUtil {
  static String? validateEmail(
    AppLocalizations localizations, {
    String? value,
  }) {
    if (value == null || value.isEmpty) {
      return localizations.login_email_error_empty;
    } else if (!_emailRegex.hasMatch(value)) {
      return localizations.login_email_error_invalid;
    } else {
      return null;
    }
  }

  static String? validatePassword(
    AppLocalizations localizations, {
    required String? value,
    int minLength = _kDefaultMinLength,
    int maxLength = _kDefaultMaxLength,
  }) {
    if (value == null || value.isEmpty) {
      return localizations.login_password_error_empty;
    } else if (value.length < minLength) {
      return localizations.login_password_error_short(minLength);
    } else if (value.length > maxLength) {
      return localizations.login_password_error_long(maxLength);
    }

    final passwordRegex =
        _composePasswordRegex(minLength: minLength, maxLength: maxLength);

    if (!passwordRegex.hasMatch(value)) {
      return localizations.login_password_error_invalid;
    } else {
      return null;
    }
  }

  static RegExp _composePasswordRegex({
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
