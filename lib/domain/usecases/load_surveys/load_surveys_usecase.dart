import 'package:enquetes/domain/core/core.dart';
import 'package:enquetes/domain/entities/entities.dart';
import 'package:enquetes/domain/usecases/load_surveys/load_surveys.dart';

abstract class LoadSurveysUseCase {
  Future<Either<LoadSurveysFailures, List<SurveyEntity>>> load();
}
