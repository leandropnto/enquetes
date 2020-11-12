import 'package:enquetes/main/factories/pages/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';

Widget makeSplashPage() =>
    SplashPage(presenter: Get.put<SplashPresenter>(makeGetxSplashPresenter()));
