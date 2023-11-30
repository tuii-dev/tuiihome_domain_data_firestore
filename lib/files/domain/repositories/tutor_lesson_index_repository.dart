import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/enums/tuii_role_type.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiientitymodels/files/auth/data/models/user_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/classroom_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/resource_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/task_model.dart';
import 'package:tuiientitymodels/files/home/data/models/home_lesson_shim.dart';

abstract class TutorLessonIndexRepository {
  Future<Either<Failure, List<LessonIndexModel>>> getTutorLessonIndexes(
      String tutorId, DateTime startDate);

  Future<Either<Failure, List<LessonModel>>> getTutorLessons(
      List<LessonIndexModel> lessonIndexes);

  Future<Either<Failure, ClassroomModel>> getLessonClassroom(
      DocumentReference classroomRef);

  Future<Either<Failure, UserModel>> getLessonStudent(
      DocumentReference studentRef);

  Future<Either<Failure, List<TaskModel>>> getLessonClassroomTasks(
      DocumentReference classroomRef, String subjectId);

  Future<Either<Failure, List<ResourceModel>>> getLessonClassroomResources(
      DocumentReference classroomRef, String subjectId);

  Future<Either<Failure, LessonIndexModel>> addTutorLessonIndex(
      LessonIndexModel lessonIndex);

  Future<Either<Failure, bool>> updateLessonWithIndex(
      HomeLessonShim lessonShim);

  Either<Failure, Stream<List<Future<LessonIndexModel>>>> getLessonIndexStream(
      {required String userId,
      required TuiiRoleType roleType,
      required DateTime lessonStartDate});

  Future<Either<Failure, List<LessonModel>>> getClassroomLessons(
      DocumentReference classroomRef, String subjectId);

  Future<Either<Failure, bool>> updatePendingSubsequentApprovalStatus(
      List<LessonIndexModel> lessonIndexes, bool isPendingSubsequentApproval);

  Future<Either<Failure, bool>> deleteLessonsAndIndexes(
      List<LessonIndexModel> lessonIndexes);
}
