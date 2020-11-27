class AddAccountFailures {
  const AddAccountFailures._();

  factory AddAccountFailures.emailInUse(String email) = EmailInUse;

  factory AddAccountFailures.unexpectedError(String message) = AddAccountUnexpectedError;
  factory AddAccountFailures.invalidCredentials(String message) = AddAccountInvalidCredentials;

  R when<R>(
    R Function(EmailInUse inUse) whenEmailInUse,
    R Function(AddAccountInvalidCredentials invalid) whenInvalidCredentials,
    R Function(AddAccountUnexpectedError unexpected) whenUnexpectedError,
    R Function() orElse,
  ) {
    if (this is EmailInUse) {
      return whenEmailInUse(this);
    } else if (this is AddAccountUnexpectedError) {
      return whenUnexpectedError(this);
    } else if (this is AddAccountInvalidCredentials) {
      return whenInvalidCredentials(this);
    } else {
      return orElse();
    }
  }
}

class EmailInUse extends AddAccountFailures {
  final String email;

  EmailInUse(this.email) : super._();
}

class AddAccountInvalidCredentials extends AddAccountFailures {
  final String email;

  AddAccountInvalidCredentials(this.email) : super._();
}

class AddAccountUnexpectedError extends AddAccountFailures {
  final String message;

  AddAccountUnexpectedError(this.message) : super._();
}
