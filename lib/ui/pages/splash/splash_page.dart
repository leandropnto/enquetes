import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash_presenter.dart';

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.checkAccount();

    return Scaffold(
      body: Builder(
        builder: (context) {
          presenter.navigateToStream.listen((route) =>
              route?.isNotEmpty == true ? Get.offAllNamed(route!!) : () {});
          return Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "4DEV...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                ),
                Text(
                  "carregando...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
