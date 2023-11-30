import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/enums/tuii_role_type.dart';
import 'package:tuiientitymodels/files/auth/data/models/user_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/resource_model.dart';
import 'package:tuiientitymodels/files/home/data/models/home_lesson_shim.dart';
import 'package:tuiientitymodels/files/classroom/data/models/classroom_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/task_model.dart';

abstract class TutorLessonIndexDataSource {
  Future<List<LessonIndexModel>> getTutorLessonIndexes(
      String tutorId, DateTime startDate);

  Future<List<LessonModel>> getTutorLessons(
      List<LessonIndexModel> lessonIndexes);

  Future<ClassroomModel> getLessonClassroom(DocumentReference classroomRef);

  Future<UserModel> getLessonStudent(DocumentReference studentRef);

  Future<List<TaskModel>> getLessonClassroomTasks(
      DocumentReference classroomRef, String subjectId);

  Future<List<ResourceModel>> getLessonClassroomResources(
      DocumentReference classroomRef, String subjectId);

  Future<LessonIndexModel> addTutorLessonIndex(LessonIndexModel lessonIndex);

  Future<bool> updateLessonWithIndex(HomeLessonShim lessonShim);

  Future<List<LessonModel>> getClassroomLessons(
      DocumentReference classroomRef, String subjectId);

  Stream<List<Future<LessonIndexModel>>> getLessonIndexStream(
      {required String userId,
      required TuiiRoleType roleType,
      required DateTime lessonStartDate});

  Future<bool> updatePendingSubsequentApprovalStatus(
      List<LessonIndexModel> lessonIndexes, bool isPendingSubsequentApproval);

  Future<bool> deleteLessonsAndIndexes(List<LessonIndexModel> lessonIndexes);
}
