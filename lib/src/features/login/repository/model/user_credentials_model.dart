import 'package:flutter/foundation.dart';

@immutable
class UserCredentialsModel {
  const UserCredentialsModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserCredentialsModel &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @override
  String toString() {
    return 'UserCredentials(email: $email, password: $password)';
  }
}
