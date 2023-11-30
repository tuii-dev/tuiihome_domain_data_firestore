import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/home/data/models/home_lesson_shim.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class UpdateLessonShimUseCase implements UseCase<bool, UpdateLessonShimParams> {
  final TutorLessonIndexRepository repository;

  UpdateLessonShimUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(UpdateLessonShimParams params) async {
    return await repository.updateLessonWithIndex(params.lessonShim);
  }
}

class UpdateLessonShimParams extends Equatable {
  final HomeLessonShim lessonShim;

  const UpdateLessonShimParams({
    required this.lessonShim,
  });

  @override
  List<Object> get props => [lessonShim];
}
