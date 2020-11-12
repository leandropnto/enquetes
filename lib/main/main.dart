import 'package:enquetes/main/factories/pages/splash/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../ui/components/components.dart';
import 'factories/factories.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Deixa a status bar branca no iOS
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return GetMaterialApp(
      title: 'Enquetes ForDev',
      debugShowCheckedModeBanner: false,
      theme: makeAppDefaultTheme(),
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: makeSplashPage, transition: Transition.fade),
        GetPage(
            name: "/login", page: makeLoginPage, transition: Transition.fadeIn),
        GetPage(
          name: "/surveys",
          page: () => Scaffold(
            appBar: AppBar(
              title: Text("4DEV"),
            ),
            body: Center(
              child: Text('ENQUETES'),
            ),
          ),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
