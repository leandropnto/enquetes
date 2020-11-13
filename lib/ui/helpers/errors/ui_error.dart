enum UIError {
  unexpected,
  invalidCredentials,
  requiredField,
  invalidField,
}

extension UIErrorExt on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return 'Credenciais Inválidas';
      case UIError.requiredField:
        return 'Campo obrigatório';
      case UIError.invalidField:
        return 'Campo inválido';
      default:
        return 'Ops... Ocorreu um erro. Por favor, tente novamente';
    }
  }
}
