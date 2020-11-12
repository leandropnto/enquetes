import 'package:enquetes/data/usecases/usecases.dart';
import 'package:enquetes/domain/usecases/usecases.dart';

import '../factories.dart';

SaveCurrentAccount makeLocalSaveCurrentAccount() =>
    LocalSaveCurrentAccount(saveSecureCacheStorage: makeLocalStorageAdapter());
