import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/ui/pages/pages.dart';

import '../../factories.dart';

LoginPresenter makeGetxLoginPresenter() => GetxLoginPresenter(
      authentication: makeRemoteAuthentication(),
      validation: makeLoginValidation(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
