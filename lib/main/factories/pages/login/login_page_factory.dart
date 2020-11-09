import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';
import 'login.dart';

// Widget makeLoginPage() => LoginPage(presenter: makeStreamLoginPresenter());
Widget makeLoginPage() =>
    LoginPage(presenter: Get.put<LoginPresenter>(makeGetxLoginPresenter()));
