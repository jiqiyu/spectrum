import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectrum/service/firestore.dart';
import 'routine_model.dart';

class Worker {
  final TaskType type; // type.name is stored in firestore as document id
  List<String> specIds;
  List<String> taskIds;
  String? description = '';

  Worker({
    required this.type,
    required this.specIds,
    required this.taskIds,
    this.description,
  });

  Future<void> addWorker(Worker worker) async {
    var ref = FirestoreService().db.collection('workers').doc(worker.type.name);
    return ref.set({
      'description': worker.description,
      'specIds': worker.specIds,
      'taskIds': worker.taskIds,
    });
  }

  Future<void> registerSpec(String specId, String worker) async {}
}

class Task {
  String? id; // auto generated doc id
  String type; // one of the task types
  String specId;
  Timestamp createdAt = Timestamp.now();
  Map<String, dynamic> data;
  // TODO: notification settings

  Task({
    this.id,
    required this.type,
    required this.specId,
    required this.data, // task data, e.g. a routine detail
  });

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'specId': specId,
      'createdAt': createdAt,
      'data': data,
    };
  }
}

enum TaskType {
  routine, // cycle
  // plan, // N days plan
  // stocktaking,
  // calendarEvent,
}

const Map<String, String> taskDescription = {
  'routine':
      'Cyclical routines, e.g. daily routine: exercise 30 mins every day or drink water every two hours, etc.',
  'plan': 'Short term or long term plan, e.g. 7 day plan, 30 day plan etc.',
  'cycleTracking': 'Track how frequently an event occurs, e.g. womens period',
};

Future<void> createTask(TaskType t, Map<String, dynamic> data) async {
  switch (t) {
    case TaskType.routine:
      await createRoutine(t, data as Routine);
      break;
  }
}

Future<String> createRoutine(TaskType t, Routine r) async {
  var ref = FirestoreService().db.collection('tasks').doc();
  await ref.set({
    'type': t.name,
    'specId': r.specId,
    'data': r.asMap,
  });

  return ref.id;
}
