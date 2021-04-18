abstract class LoadSurveysFailures {
  const LoadSurveysFailures._();

  factory LoadSurveysFailures.empty() = EmptyFailure;

  factory LoadSurveysFailures.serverError(String message) = ServerError;

  R when<R>({
    required R Function() empty,
    required R Function(String message) serverError,
    R Function()? orElse,
  }) {
    if (this is EmptyFailure) {
      return empty();
    } else if (this is ServerError) {
      return serverError((this as ServerError).message);
    }
    return orElse?.call() ?? empty();
  }
}

class EmptyFailure extends LoadSurveysFailures {
  EmptyFailure() : super._();
}

class ServerError extends LoadSurveysFailures {
  final String message;

  ServerError(this.message) : super._();
}
