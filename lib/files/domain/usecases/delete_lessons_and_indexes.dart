import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class DeleteLessonsAndIndexesUseCase
    implements UseCase<bool, DeleteLessonsAndIndexesParams> {
  final TutorLessonIndexRepository repository;

  DeleteLessonsAndIndexesUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(
      DeleteLessonsAndIndexesParams params) async {
    return await repository.deleteLessonsAndIndexes(params.lessonIndexes);
  }
}

class DeleteLessonsAndIndexesParams extends Equatable {
  final List<LessonIndexModel> lessonIndexes;

  const DeleteLessonsAndIndexesParams({
    required this.lessonIndexes,
  });

  @override
  List<Object> get props => [lessonIndexes];
}
