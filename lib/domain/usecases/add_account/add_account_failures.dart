class AddAccountFailures {
  const AddAccountFailures._();

  factory AddAccountFailures.emailInUse(String email) = EmailInUse;
  factory AddAccountFailures.unexpectedError(Exception exception) = UnexpectedError;

  R when<R>(R Function(EmailInUse failure) whenEmailInUse, R Function(UnexpectedError failure) whenUnexpectedError,
      R Function() orElse) {
    if (this is EmailInUse) {
      return whenEmailInUse(this);
    } else if (this is UnexpectedError) {
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

class UnexpectedError extends AddAccountFailures {
  final Exception exception;
  UnexpectedError(this.exception) : super._();
}
