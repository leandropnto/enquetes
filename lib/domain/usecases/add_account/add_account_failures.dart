class AddAccountFailures {
  const AddAccountFailures._();

  factory AddAccountFailures.emailInUse(String email) = EmailInUse;

  factory AddAccountFailures.unexpectedError(String message) = AddAccountUnexpectedError;

  R when<R>(
    R Function(EmailInUse failure) whenEmailInUse,
    R Function(AddAccountUnexpectedError failure) whenUnexpectedError,
    R Function() orElse,
  ) {
    if (this is EmailInUse) {
      return whenEmailInUse(this);
    } else if (this is AddAccountUnexpectedError) {
      return whenUnexpectedError(this);
    } else {
      return orElse();
    }
  }
}

class EmailInUse extends AddAccountFailures {
  final String email;

  EmailInUse(this.email) : super._();
}

class AddAccountUnexpectedError extends AddAccountFailures {
  final String message;

  AddAccountUnexpectedError(this.message) : super._();
}
