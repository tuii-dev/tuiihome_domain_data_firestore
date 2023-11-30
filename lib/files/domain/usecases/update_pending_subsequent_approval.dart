import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class UpdateLessonIndexesSubsequentApprovalUseCase
    implements UseCase<bool, UpdateSubsequentApprovalParams> {
  final TutorLessonIndexRepository repository;

  UpdateLessonIndexesSubsequentApprovalUseCase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(
      UpdateSubsequentApprovalParams params) async {
    return await repository.updatePendingSubsequentApprovalStatus(
        params.lessonIndexes, params.isPendingSubsequentApproval);
  }
}

class UpdateSubsequentApprovalParams extends Equatable {
  final List<LessonIndexModel> lessonIndexes;
  final bool isPendingSubsequentApproval;

  const UpdateSubsequentApprovalParams({
    required this.lessonIndexes,
    required this.isPendingSubsequentApproval,
  });

  @override
  List<Object> get props => [lessonIndexes, isPendingSubsequentApproval];
}
