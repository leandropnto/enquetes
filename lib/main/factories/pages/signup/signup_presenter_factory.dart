import 'package:enquetes/presentation/presenters/presenters.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';

import '../../factories.dart';

SignUpPresenter makeGetxSignupPresenter() => GetxSignUpPresenter(
    validation: makeLoginValidation(),
    addAccount: makeAddCurrentAccount(),
    saveCurrentAccount: makeLocalSaveCurrentAccount());
