import '../../domain/entities/entities.dart';
import '../../domain/helpers/helpers.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      json.containsKey('accessToken')
          ? RemoteAccountModel(json['accessToken'])
          : throw DomainError.invalidCredentials;

  AccountEntity toEntity() => AccountEntity(accessToken);
}
