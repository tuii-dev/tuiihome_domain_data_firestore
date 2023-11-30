import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/auth/data/models/user_model.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class GetLessonStudentUseCase
    implements UseCase<UserModel, GetLessonStudentParams> {
  final TutorLessonIndexRepository repository;

  GetLessonStudentUseCase({required this.repository});

  @override
  Future<Either<Failure, UserModel>> call(GetLessonStudentParams params) async {
    return await repository.getLessonStudent(params.studentRef);
  }
}

class GetLessonStudentParams extends Equatable {
  final DocumentReference studentRef;

  const GetLessonStudentParams({
    required this.studentRef,
  });

  @override
  List<Object> get props => [studentRef];
}
