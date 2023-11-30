import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetClassroomLessonsUseCase
    implements UseCase<List<LessonModel>, GetClassroomLessonsParams> {
  final TutorLessonIndexRepository repository;

  GetClassroomLessonsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LessonModel>>> call(
      GetClassroomLessonsParams params) async {
    return await repository.getClassroomLessons(
        params.classroomRef, params.subjectId);
  }
}

class GetClassroomLessonsParams extends Equatable {
  final DocumentReference classroomRef;
  final String subjectId;

  const GetClassroomLessonsParams({
    required this.classroomRef,
    required this.subjectId,
  });

  @override
  List<Object> get props => [classroomRef, subjectId];
}
