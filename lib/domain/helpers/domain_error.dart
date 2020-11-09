enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExt on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais Inválidas';
      default:
        return 'Ocorreu um erro. Por favor, tente novamente';
    }
  }
}
