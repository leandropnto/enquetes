import 'package:enquetes/infra/cache/cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

LocalStorageAdapter makeLocalStorageAdapter() =>
    LocalStorageAdapter(secureStorage: FlutterSecureStorage());
