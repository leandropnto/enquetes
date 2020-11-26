import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParams({
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.passwordConfirmation,
  });

  @override
  List<Object> get props => [
        email,
        email,
        password,
        passwordConfirmation,
      ];
}
