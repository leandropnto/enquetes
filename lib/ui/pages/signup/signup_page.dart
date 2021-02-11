import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignupPage extends StatefulWidget {
  final SignUpPresenter presenter;

  const SignupPage({Key key, this.presenter}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(
      builder: (context) {
        widget.presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context, message: "Criando a conta...");
          } else {
            hideLoading(context);
          }
        });

        widget.presenter.navigateStream.listen(
            (page) => page?.isNotEmpty == true ? Get.offAllNamed(page) : {});
        widget.presenter.mainErrorStream.listen((error) {
          if (error != null) {
            showErrorMessage(context, error.description);
          }
        });
        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginHeader(),
                HeadLine1(text: "BEM-VINDO AO\nENQUETES"),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: [
                        NameInput(),
                        SizedBox(height: 16),
                        EmailInput(),
                        SizedBox(height: 16),
                        PasswordInput(),
                        SizedBox(height: 16),
                        SignupButton(),
                        PasswordConfirmationInput(),
                        SizedBox(height: 16),
                        FlatButton.icon(
                          onPressed: widget.presenter.goToLogin,
                          icon: Icon(Icons.exit_to_app),
                          label: Text(R.strings.login),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }

  void _hideKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
