import '../../core/core.dart';
import '../../entities/entities.dart';
import 'add_account_failures.dart';
import 'add_account_params.dart';

abstract class AddAccountUseCase {
  Future<Either<AddAccountFailures, AccountEntity>> add(AddAccountParams params);
}
