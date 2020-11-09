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
      initialRoute: "/login",
      getPages: [GetPage(name: "/login", page: makeLoginPage)],
    );
  }
}
