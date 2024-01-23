import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:red_bull_flutter_case_study/src/features/login/repository/model/user_credentials_model.dart';

const _kEmailStorageKey = 'user-credentials_email';
const _kPasswordStorageKey = 'user-credentials_password';

class UserCredentialsRepository {
  UserCredentialsRepository([
    FlutterSecureStorage? secureStorage,
  ]) : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _secureStorage;

  final ValueNotifier<UserCredentialsModel?> _credentials = ValueNotifier(null);
  ValueNotifier<UserCredentialsModel?> get credentials => _credentials;

  Future<void> get() async {
    final result = await Future.wait([
      _secureStorage.read(key: _kEmailStorageKey),
      _secureStorage.read(key: _kPasswordStorageKey),
    ]);

    final email = result.first;
    final password = result.last;

    final credentials = email != null && password != null
        ? UserCredentialsModel(email: email, password: password)
        : null;

    _credentials.value = credentials;
  }

  Future<void> save(UserCredentialsModel credentials) async {
    await Future.wait([
      _secureStorage.write(key: _kEmailStorageKey, value: credentials.email),
      _secureStorage.write(
        key: _kPasswordStorageKey,
        value: credentials.password,
      ),
    ]);

    _credentials.value = credentials;
  }

  Future<void> delete() async {
    await Future.wait([
      _secureStorage.delete(key: _kEmailStorageKey),
      _secureStorage.delete(key: _kPasswordStorageKey),
    ]);

    _credentials.value = null;
  }
}
