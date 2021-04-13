import 'package:enquetes/main/factories/pages/signup/signup.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:enquetes/ui/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makeSignupPage() =>
    SignupPage(presenter: Get.put<SignUpPresenter>(makeGetxSignupPresenter()));
