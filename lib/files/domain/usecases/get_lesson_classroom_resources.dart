import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/resource_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonClassroomResourcesUseCase
    implements UseCase<List<ResourceModel>, GetLessonClassroomResourcesParams> {
  final TutorLessonIndexRepository repository;

  GetLessonClassroomResourcesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ResourceModel>>> call(
      GetLessonClassroomResourcesParams params) async {
    return await repository.getLessonClassroomResources(
        params.classroomRef, params.subjectId);
  }
}

class GetLessonClassroomResourcesParams extends Equatable {
  final DocumentReference classroomRef;
  final String subjectId;

  const GetLessonClassroomResourcesParams({
    required this.classroomRef,
    required this.subjectId,
  });

  @override
  List<Object> get props => [classroomRef, subjectId];
}
