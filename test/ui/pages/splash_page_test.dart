import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

abstract class SplashPresenter {
  Future<void> loadCurrentAccount();
}

class SplashPagePresenterSpy extends Mock implements SplashPresenter {}

class SplashPage extends StatelessWidget {
  final SplashPresenter presenter;

  const SplashPage({Key key, @required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    presenter.loadCurrentAccount();

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  //Variables

  SplashPresenter presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPagePresenterSpy();

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: "/",
        getPages: [
          GetPage(name: "/", page: () => SplashPage(presenter: presenter)),
        ],
      ),
    );
  }
  //Mocks

  //helpers

  testWidgets('Should present loading on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadCurrentAccount()).called(1);
  });
}
