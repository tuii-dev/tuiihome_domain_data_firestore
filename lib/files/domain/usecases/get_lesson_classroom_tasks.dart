import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/task_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonClassroomTasksUseCase
    implements UseCase<List<TaskModel>, GetLessonClassroomTasksParams> {
  final TutorLessonIndexRepository repository;

  GetLessonClassroomTasksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<TaskModel>>> call(
      GetLessonClassroomTasksParams params) async {
    return await repository.getLessonClassroomTasks(
        params.classroomRef, params.subjectId);
  }
}

class GetLessonClassroomTasksParams extends Equatable {
  final DocumentReference classroomRef;
  final String subjectId;

  const GetLessonClassroomTasksParams({
    required this.classroomRef,
    required this.subjectId,
  });

  @override
  List<Object> get props => [classroomRef, subjectId];
}
