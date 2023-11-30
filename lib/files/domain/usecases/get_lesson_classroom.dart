import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/classroom_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonClassroomUseCase
    implements UseCase<ClassroomModel, GetLessonClassroomParams> {
  final TutorLessonIndexRepository repository;

  GetLessonClassroomUseCase({required this.repository});

  @override
  Future<Either<Failure, ClassroomModel>> call(
      GetLessonClassroomParams params) async {
    return await repository.getLessonClassroom(params.classroomRef);
  }
}

class GetLessonClassroomParams extends Equatable {
  final DocumentReference classroomRef;

  const GetLessonClassroomParams({
    required this.classroomRef,
  });

  @override
  List<Object> get props => [classroomRef];
}
