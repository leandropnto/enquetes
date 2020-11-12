import 'dart:async';

import 'package:enquetes/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SplashPagePresenterSpy extends Mock implements SplashPresenter {}

void main() {
  //Variables

  SplashPresenter presenter;
  StreamController navigateToController;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPagePresenterSpy();
    navigateToController = StreamController<String>();

    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: "/",
        getPages: [
          GetPage(name: "/", page: () => SplashPage(presenter: presenter)),
          GetPage(
            name: "/any_route",
            page: () => Scaffold(
              body: Text('fake page'),
            ),
          ),
        ],
      ),
    );
  }
  //Mocks

  //helpers

  tearDown(() {
    navigateToController.close();
  });

  testWidgets('Should present loading on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call loadCurrentAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('Should  load page ', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, "/any_route");
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not load page ', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();
    expect(Get.currentRoute, "/");

    navigateToController.add(null);
    await tester.pump();
    expect(Get.currentRoute, "/");
  });
}
