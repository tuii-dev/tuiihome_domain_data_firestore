import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class AddLessonIndexUseCase
    implements UseCase<LessonIndexModel, AddLessonIndexParams> {
  final TutorLessonIndexRepository repository;

  AddLessonIndexUseCase({required this.repository});

  @override
  Future<Either<Failure, LessonIndexModel>> call(
      AddLessonIndexParams params) async {
    return await repository.addTutorLessonIndex(params.lessonIndex);
  }
}

class AddLessonIndexParams extends Equatable {
  final LessonIndexModel lessonIndex;

  const AddLessonIndexParams({
    required this.lessonIndex,
  });

  @override
  List<Object> get props => [lessonIndex];
}
