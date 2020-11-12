import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

import '../factories.dart';

LoadCurrentAccount makeLocalLoadCurrentAccount() =>
    LocalLoadCurrentAccount(fetchSecureCacheStorage: makeLocalStorageAdapter());
