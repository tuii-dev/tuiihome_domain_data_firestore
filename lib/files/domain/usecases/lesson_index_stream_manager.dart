import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tuiicore/core/common/tutor_lesson_index_model.dart';
import 'package:tuiicore/core/enums/tuii_role_type.dart';
import 'package:tuiihome_domain_data_firestore/files/domain/repositories/tutor_lesson_index_repository.dart';

class LessonIndexStreamManager {
  final List<StreamSubscription<List<Future<LessonIndexModel>>>?>
      _lessonIndexSubscriptions = [];

  StreamController<List<LessonIndexModel>>? _streamController;

  LessonIndexStreamManager(
      {required this.userId,
      required this.roleType,
      required this.lessonStartDate,
      required this.repository}) {
    _streamController = StreamController<List<LessonIndexModel>>();
  }

  final String userId;
  final TuiiRoleType roleType;
  final DateTime lessonStartDate;
  final TutorLessonIndexRepository repository;

  Stream<List<LessonIndexModel>> get stream =>
      _streamController!.stream.asBroadcastStream();

  void close() {
    // _payloadQueueTimer.cancel();
    for (var sub in _lessonIndexSubscriptions) {
      try {
        sub?.cancel();
      } catch (e) {
        debugPrint('Lesson index subscription cancellation failed.');
      }
    }
  }

  void init() {
    _initStream();
  }

  void _initStream() {
    final lessonIndexEither = repository.getLessonIndexStream(
        userId: userId, roleType: roleType, lessonStartDate: lessonStartDate);
    lessonIndexEither.fold((error) {
      // TODO: ERROR LOGGING INFRASTRUCTURE
      // errorLog.add(error.message ?? '');
      debugPrint(
          'Failed to open lesson index stream.  Message: ${error.message}');
    }, (lessonIndexStream) {
      var sub = lessonIndexStream.listen((lessonFutures) async {
        final lessonIndexes = await Future.wait(lessonFutures);

        _streamController?.sink.add(lessonIndexes);
      });

      _lessonIndexSubscriptions.add(sub);
    });
  }
}
