import 'dart:async';

import 'package:enquetes/ui/helpers/errors/errors.dart';
import 'package:enquetes/ui/pages/signup/signup.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;
  StreamController<UIError> nameErrorController;
  StreamController<UIError> emailErrorController;
  StreamController<UIError> passwordErrorController;
  StreamController<UIError> passwordConfirmationErrorController;
  StreamController<bool> isFormValidController;
  StreamController<bool> isLoadingController;
  StreamController<UIError> mainErrorController;
  StreamController<String> navigationController;

  void initStreams() {
    nameErrorController = StreamController<UIError>();
    emailErrorController = StreamController<UIError>();
    passwordErrorController = StreamController<UIError>();
    passwordConfirmationErrorController = StreamController<UIError>();
    isFormValidController = StreamController<bool>();
    isLoadingController = StreamController<bool>();
    mainErrorController = StreamController<UIError>();
    navigationController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.nameErrorStream)
        .thenAnswer((realInvocation) => nameErrorController.stream);

    when(presenter.emailErrorStream)
        .thenAnswer((_) => emailErrorController.stream);

    when(presenter.passwordErrorStream)
        .thenAnswer((_) => passwordErrorController.stream);

    when(presenter.passwordConfirmationErrorStream)
        .thenAnswer((_) => passwordConfirmationErrorController.stream);

    when(presenter.isFormValidStream)
        .thenAnswer((_) => isFormValidController.stream);

    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.mainErrorStream)
        .thenAnswer((_) => mainErrorController.stream);

    when(presenter.navigateStream)
        .thenAnswer((_) => navigationController.stream);
  }

  void closeStreams() {
    nameErrorController.close();
    emailErrorController.close();
    passwordErrorController.close();
    passwordConfirmationErrorController.close();
    isFormValidController.close();
    isLoadingController.close();
    mainErrorController.close();
    navigationController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<SignUpPresenter>(SignUpPresenterSpy());

    initStreams();

    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: "/signup",
      getPages: [
        GetPage(
            name: "/signup",
            page: () => SignupPage(
                  presenter: presenter,
                )),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));

    expect(
      nameTextChildren,
      findsOneWidget,
    );

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(
      emailTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no erros, since one of the children is always the label text',
    );

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));

    expect(
      passwordTextChildren,
      findsOneWidget,
      reason:
          'When a TextFormField has only one text child, means it has no erros, since one of the children is always the label text',
    );

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar senha'),
        matching: find.byType(Text));

    expect(
      passwordConfirmationTextChildren,
      findsOneWidget,
    );

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNull);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should call validate with correct values',
      (WidgetTester tester) async {
    await loadPage(tester);

    final name = faker.person.name();
    await tester.enterText(find.bySemanticsLabel('Nome'), name);
    verify(presenter.validateName(name));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(presenter.validatePassword(password));

    await tester.enterText(find.bySemanticsLabel('Confirmar senha'), password);
    verify(presenter.validatePasswordConfirmation(password));
  });

  group('Email', () {
    testWidgets('Should present error  ', (WidgetTester tester) async {
      await loadPage(tester);

      emailErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);

      emailErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);

      emailErrorController.add(null);
      await tester.pump();

      expect(
          find.descendant(
              of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
          findsOneWidget);
    });
  });

  group('Name', () {
    testWidgets('Should present name error ', (WidgetTester tester) async {
      await loadPage(tester);

      nameErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);

      nameErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);

      nameErrorController.add(null);
      await tester.pump();

      expect(
          find.descendant(
              of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
          findsOneWidget);
    });
  });

  group('Password', () {
    testWidgets('Should present Password error ', (WidgetTester tester) async {
      await loadPage(tester);

      passwordErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);

      passwordErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);

      passwordErrorController.add(null);
      await tester.pump();

      expect(
          find.descendant(
              of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
          findsOneWidget);
    });
  });

  group('Password confirmation', () {
    testWidgets('Should present Password confirmation error ',
        (WidgetTester tester) async {
      await loadPage(tester);

      passwordConfirmationErrorController.add(UIError.invalidField);
      await tester.pump();

      expect(find.text('Campo inválido'), findsOneWidget);

      passwordConfirmationErrorController.add(UIError.requiredField);
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);

      passwordConfirmationErrorController.add(null);
      await tester.pump();

      expect(
          find.descendant(
              of: find.bySemanticsLabel('Confirmar senha'),
              matching: find.byType(Text)),
          findsOneWidget);
    });
  });

  group('Button', () {
    testWidgets('Should enable button if form is valid',
        (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Should disable button if form is invalid',
        (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(false);
      await tester.pump();

      final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
      expect(button.onPressed, null);
    });

    testWidgets('Should call signup on form submit',
        (WidgetTester tester) async {
      await loadPage(tester);

      isFormValidController.add(true);
      await tester.pump();
      final button = find.byType(RaisedButton);
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      verify(presenter.signUp()).called(1);
    });
  });

  tearDown(() {
    closeStreams();
  });
}
