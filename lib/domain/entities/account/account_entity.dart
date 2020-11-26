import 'package:equatable/equatable.dart';

import 'account.dart';

class AccountEntity extends Equatable {
  final Token token;

  AccountEntity(this.token);

  @override
  List<Object> get props => [token];
}
