import 'package:enquetes/data/http/http.dart';
import 'package:enquetes/domain/core/either.dart';
import 'package:enquetes/domain/entities/survey/survey_entity.dart';
import 'package:enquetes/domain/usecases/load_surveys/load_surveys.dart';

class RemoteLoadSurveys implements LoadSurveysUseCase {
  final String url;
  final HttpClient client;

  RemoteLoadSurveys({required this.url, required this.client});

  @override
  Future<Either<LoadSurveysFailures, List<SurveyEntity>>> load() {
    return Future.delayed(Duration(seconds: 2)).then(
      (value) => [
        SurveyEntity(
          id: "0",
          question: "",
          dateTime: DateTime.now(),
          didAnswer: false,
        ),
      ].right(),
    );
  }
}
