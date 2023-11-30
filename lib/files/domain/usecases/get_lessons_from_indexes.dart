import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonsFromIndexesUseCase
    implements UseCase<List<LessonModel>, GetLessonsFromIndexesParams> {
  final TutorLessonIndexRepository repository;

  GetLessonsFromIndexesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LessonModel>>> call(
      GetLessonsFromIndexesParams params) async {
    return await repository.getTutorLessons(params.lessonIndexes);
  }
}

class GetLessonsFromIndexesParams extends Equatable {
  final List<LessonIndexModel> lessonIndexes;

  const GetLessonsFromIndexesParams({
    required this.lessonIndexes,
  });

  @override
  List<Object> get props => [lessonIndexes];
}
