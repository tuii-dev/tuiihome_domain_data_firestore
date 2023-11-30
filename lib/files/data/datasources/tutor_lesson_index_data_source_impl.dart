import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/config/paths.dart';
import 'package:tuiicore/core/enums/tuii_role_type.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiientitymodels/files/auth/data/models/user_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/resource_model.dart';
import 'package:tuiientitymodels/files/home/data/models/home_lesson_shim.dart';
import 'package:tuiientitymodels/files/classroom/data/models/classroom_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/task_model.dart';
import 'package:tuiihome_domain_data_firestore/files/data/datasources/tutor_lesson_index_data_source.dart';

class TutorLessonIndexDataSourceImpl extends TutorLessonIndexDataSource {
  final FirebaseFirestore firestore;

  TutorLessonIndexDataSourceImpl({
    required this.firestore,
  });

  @override
  Future<List<LessonIndexModel>> getTutorLessonIndexes(
      String tutorId, DateTime startDate) async {
    try {
      final docs = await firestore
          .collection(Paths.tutorLessonIndex)
          .where('tutorId', isEqualTo: tutorId)
          .where('startDate',
              isGreaterThanOrEqualTo: startDate.toUtc().millisecondsSinceEpoch)
          .get();

      if (docs.docs.isNotEmpty) {
        return docs.docs
            .map((doc) => LessonIndexModel.fromMap(doc.data()))
            .toList();
      } else {
        return [];
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      throw const Failure(message: 'Failed to get tutor lesson indexes');
    } on Exception {
      throw const Failure(message: 'Failed to get tutor lesson indexes');
    }
  }

  @override
  Future<List<LessonModel>> getTutorLessons(
      List<LessonIndexModel> lessonIndexes) async {
    List<LessonModel> lessons = [];

    for (LessonIndexModel lessonIndex in lessonIndexes) {
      if (lessonIndex.lessonRef != null) {
        final doc = await lessonIndex.lessonRef!.get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          lessons.add(LessonModel.fromMap(data));
        }
      }
    }

    lessons.sort((b, a) => a.startDate!.compareTo(b.startDate!));

    return lessons;
  }

  @override
  Future<ClassroomModel> getLessonClassroom(
      DocumentReference classroomRef) async {
    final doc = await classroomRef.get();
    final map = doc.data() as Map<String, dynamic>;
    return ClassroomModel.fromMap(map);
  }

  @override
  Future<UserModel> getLessonStudent(DocumentReference studentRef) async {
    final doc = await studentRef.get();
    final map = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(map);
  }

  @override
  Future<List<TaskModel>> getLessonClassroomTasks(
      DocumentReference classroomRef, String subjectId) async {
    final docs = await classroomRef
        .collection(Paths.tasks)
        .where('subjectId', isEqualTo: subjectId)
        .get();

    if (docs.docs.isNotEmpty) {
      return docs.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  @override
  Future<List<ResourceModel>> getLessonClassroomResources(
      DocumentReference classroomRef, String subjectId) async {
    final docs = await classroomRef
        .collection(Paths.resources)
        .where('subjectId', isEqualTo: subjectId)
        .get();

    if (docs.docs.isNotEmpty) {
      return docs.docs.map((doc) => ResourceModel.fromMap(doc.data())).toList();
    } else {
      return [];
    }
  }

  @override
  Future<LessonIndexModel> addTutorLessonIndex(
      LessonIndexModel lessonIndex) async {
    try {
      final doc = await firestore
          .collection(Paths.tutorLessonIndex)
          .add(lessonIndex.toMap());

      return lessonIndex.copyWith(id: doc.id);
    } on Exception {
      throw const Failure(message: 'Failed to add tutor lesson index.');
    }
  }

  @override
  Future<bool> updateLessonWithIndex(HomeLessonShim lessonShim) async {
    try {
      await firestore.runTransaction((transaction) async {
        final lessonRef = firestore
            .collection(Paths.classrooms)
            .doc(lessonShim.classroom.id)
            .collection(Paths.lessons)
            .doc(lessonShim.lesson.id);
        transaction.update(lessonRef, lessonShim.lesson.toMap());

        final lessonIndexRef = firestore
            .collection(Paths.tutorLessonIndex)
            .doc(lessonShim.lessonIndex.id);
        transaction.update(lessonIndexRef, lessonShim.lessonIndex.toMap());
      });

      return true;
    } on Exception {
      throw const Failure(message: 'Failed to add tutor lesson index.');
    }
  }

  @override
  Future<bool> updatePendingSubsequentApprovalStatus(
      List<LessonIndexModel> lessonIndexes,
      bool isPendingSubsequentApproval) async {
    try {
      await firestore.runTransaction((transaction) async {
        for (var lessonIndex in lessonIndexes) {
          transaction.update(lessonIndex.lessonRef!,
              {'isPendingSubsequentApproval': isPendingSubsequentApproval});

          final lessonIndexRef =
              firestore.collection(Paths.tutorLessonIndex).doc(lessonIndex.id);
          transaction.update(lessonIndexRef,
              {'isPendingSubsequentApproval': isPendingSubsequentApproval});
        }
      });

      return true;
    } on Exception {
      throw const Failure(
          message: 'Failed to update lessons and lesson indexes.');
    }
  }

  @override
  Future<bool> deleteLessonsAndIndexes(
      List<LessonIndexModel> lessonIndexes) async {
    try {
      await firestore.runTransaction((transaction) async {
        for (var lessonIndex in lessonIndexes) {
          transaction.delete(lessonIndex.lessonRef!);

          final lessonIndexRef =
              firestore.collection(Paths.tutorLessonIndex).doc(lessonIndex.id);
          transaction.delete(lessonIndexRef);
        }
      });

      return true;
    } on Exception {
      throw const Failure(
          message: 'Failed to delete lessons and lesson indexes.');
    }
  }

  @override
  Stream<List<Future<LessonIndexModel>>> getLessonIndexStream(
      {required String userId,
      required TuiiRoleType roleType,
      required DateTime lessonStartDate}) {
    try {
      final field = roleType == TuiiRoleType.tutor
          ? 'tutorId'
          : roleType == TuiiRoleType.student
              ? 'studentId'
              : 'studentCustodianId';
      return firestore
          .collection(Paths.tutorLessonIndex)
          .where(field, isEqualTo: userId)
          .where('startDate',
              isGreaterThanOrEqualTo:
                  lessonStartDate.toUtc().millisecondsSinceEpoch)
          // .where('lessonRefunded', isEqualTo: false)
          .snapshots()
          .map((snaps) => snaps.docs.map((doc) async {
                var index = LessonIndexModel.fromMap(doc.data());
                index = index.copyWith(id: doc.id);
                return index;
              }).toList());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      throw const Failure(message: 'Failed to get tutor lesson indexes');
    } on Exception {
      throw const Failure(message: 'Failed to get tutor lesson indexes');
    }
  }

  @override
  Future<List<LessonModel>> getClassroomLessons(
      DocumentReference classroomRef, String subjectId) async {
    try {
      // final docs = await firestore
      //     .collection(Paths.classrooms)
      //     .doc(classroomId)
      //     .collection(Paths.lessons)
      //     .get();

      final docs = await classroomRef
          .collection(Paths.lessons)
          .where('subjectId', isEqualTo: subjectId)
          .orderBy('startDate')
          .get();

      if (docs.size > 0) {
        return docs.docs.map((e) => LessonModel.fromMap(e.data())).toList();
      } else {
        return [];
      }
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      throw const Failure(message: 'Failed to get classroom lessons');
    } on Exception {
      throw const Failure(message: 'Failed to get classroom lessons');
    }
  }
}
