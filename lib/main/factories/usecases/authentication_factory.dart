import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../http/http.dart';

Authentication makeRemoteAuthentication() =>
    RemoteAuthentication(httpClient: makeHttpAdapter(), url: makeApiUrl());
