import 'package:enquetes/data/usecases/add_account/add_account.dart';
import 'package:enquetes/domain/usecases/add_account/add_account.dart';

import '../factories.dart';

AddAccount makeAddCurrentAccount() =>
    RemoteAddAccount(httpClient: makeHttpAdapter(), url: "");
