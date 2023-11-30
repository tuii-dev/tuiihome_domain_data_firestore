import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/enums/tuii_role_type.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/usecases/lesson_index_stream_manager.dart';

class GetLessonIndexStreamManager
    implements
        SyncUseCase<LessonIndexStreamManager,
            GetLessonIndexStreamManagerParams> {
  final TutorLessonIndexRepository repository;

  GetLessonIndexStreamManager({required this.repository});

  @override
  Either<Failure, LessonIndexStreamManager> call(
      GetLessonIndexStreamManagerParams params) {
    final streamManager = LessonIndexStreamManager(
        userId: params.userId,
        roleType: params.roleType,
        lessonStartDate: params.lessonStartDate,
        repository: repository);

    return Right(streamManager);
  }
}

class GetLessonIndexStreamManagerParams extends Equatable {
  final String userId;
  final TuiiRoleType roleType;
  final DateTime lessonStartDate;

  const GetLessonIndexStreamManagerParams(
      {required this.userId,
      required this.roleType,
      required this.lessonStartDate});

  @override
  List<Object> get props => [userId, roleType, lessonStartDate];
}
