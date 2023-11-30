import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonIndexesUseCase
    implements UseCase<List<LessonIndexModel>, GetLessonIndexesParams> {
  final TutorLessonIndexRepository repository;

  GetLessonIndexesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LessonIndexModel>>> call(
      GetLessonIndexesParams params) async {
    return await repository.getTutorLessonIndexes(
        params.tutorId, params.startDate);
  }
}

class GetLessonIndexesParams extends Equatable {
  final String tutorId;
  final DateTime startDate;

  const GetLessonIndexesParams({
    required this.tutorId,
    required this.startDate,
  });

  @override
  List<Object> get props => [tutorId, startDate];
}
