import 'package:enquetes/data/models/models.dart';
import 'package:enquetes/domain/core/core.dart';

import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import 'remote_add_account_params.dart';

class RemoteAddAccount implements AddAccountUseCase {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  Future<Either<AddAccountFailures, AccountEntity>> add(
      AddAccountParams params) async {
    try {
      final body = RemoteAddAccountParams.fromDomain(params).toJson();
      final httpResponse =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity().right();
    } on HttpError catch (error) {
      if (error == HttpError.forbidden) {
        return AddAccountFailures.emailInUse(params.email).left();
      } else if (error == HttpError.unauthorized) {
        return AddAccountFailures.invalidCredentials(params.email).left();
      }

      return AddAccountFailures.unexpectedError("Erro adicionando").left();
    }
  }
}
