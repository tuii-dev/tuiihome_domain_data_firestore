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
import 'package:tuiihome_domain_data_firestore/files/data/datasources/tutor_lesson_index_data_source.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class TutorLessonIndexRepositoryImpl extends TutorLessonIndexRepository {
  final TutorLessonIndexDataSource dataSource;
  TutorLessonIndexRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, List<LessonIndexModel>>> getTutorLessonIndexes(
      String tutorId, DateTime startDate) async {
    try {
      final lessonIndexes =
          await dataSource.getTutorLessonIndexes(tutorId, startDate);
      return Right(lessonIndexes);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, List<LessonModel>>> getTutorLessons(
      List<LessonIndexModel> lessonIndexes) async {
    try {
      final lessons = await dataSource.getTutorLessons(lessonIndexes);
      return Right(lessons);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, LessonIndexModel>> addTutorLessonIndex(
      LessonIndexModel lessonIndex) async {
    try {
      final newIndex = await dataSource.addTutorLessonIndex(lessonIndex);
      return Right(newIndex);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, bool>> updateLessonWithIndex(
      HomeLessonShim lessonShim) async {
    try {
      final success = await dataSource.updateLessonWithIndex(lessonShim);
      return Right(success);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, ClassroomModel>> getLessonClassroom(
      DocumentReference classroomRef) async {
    try {
      final classroom = await dataSource.getLessonClassroom(classroomRef);
      return Right(classroom);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, UserModel>> getLessonStudent(
      DocumentReference studentRef) async {
    try {
      final student = await dataSource.getLessonStudent(studentRef);
      return Right(student);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, List<TaskModel>>> getLessonClassroomTasks(
      DocumentReference classroomRef, String subjectId) async {
    try {
      final tasks =
          await dataSource.getLessonClassroomTasks(classroomRef, subjectId);
      return Right(tasks);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, List<ResourceModel>>> getLessonClassroomResources(
      DocumentReference classroomRef, String subjectId) async {
    try {
      final resources =
          await dataSource.getLessonClassroomResources(classroomRef, subjectId);
      return Right(resources);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Either<Failure, Stream<List<Future<LessonIndexModel>>>> getLessonIndexStream(
      {required String userId,
      required TuiiRoleType roleType,
      required DateTime lessonStartDate}) {
    try {
      final stream = dataSource.getLessonIndexStream(
          userId: userId, roleType: roleType, lessonStartDate: lessonStartDate);
      return Right(stream);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, List<LessonModel>>> getClassroomLessons(
      DocumentReference classroomRef, String subjectId) async {
    try {
      final lessons =
          await dataSource.getClassroomLessons(classroomRef, subjectId);
      return Right(lessons);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, bool>> updatePendingSubsequentApprovalStatus(
      List<LessonIndexModel> lessonIndexes,
      bool isPendingSubsequentApproval) async {
    try {
      final success = await dataSource.updatePendingSubsequentApprovalStatus(
          lessonIndexes, isPendingSubsequentApproval);
      return Right(success);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteLessonsAndIndexes(
      List<LessonIndexModel> lessonIndexes) async {
    try {
      final success = await dataSource.deleteLessonsAndIndexes(lessonIndexes);
      return Right(success);
    } on Failure catch (err) {
      return Left(err);
    }
  }
}
