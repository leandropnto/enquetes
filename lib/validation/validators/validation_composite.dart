import 'package:enquetes/presentation/protocols/protocols.dart';
import 'package:enquetes/validation/protocols/protocols.dart';
import 'package:meta/meta.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite(this.validations);

  @override
  String validate({@required String field, @required String value}) {
    return validations
        .where((validation) => validation.field == field)
        .map((validation) => validation.validate(value))
        .firstWhere(
          (element) => element?.isNotEmpty == true,
          orElse: () => null,
        );
  }
}
