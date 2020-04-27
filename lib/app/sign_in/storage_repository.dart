import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mifadeschats/app/sign_in/storage_provider.dart';

class StorageRepository {
  final _store =
      StorageProvider(flutterSecureStorage: new FlutterSecureStorage());

  Future<void> setEmail(String email) => _store.setEmail(email);

  Future<void> clearEmail() => _store.clearEmail();

  Future<String> getEmail() => _store.getEmail();
}
