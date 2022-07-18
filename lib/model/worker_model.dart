import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectrum/model/spectrum_model.dart';
import 'package:spectrum/service/firestore.dart';
import 'routine_model.dart';

class Worker {
  final TaskType type; // type.name is stored in firestore as document id
  List<String> specNames;
  List<String> taskIds;
  String? description;

  Worker({
    required this.type,
    required this.specNames,
    required this.taskIds,
    this.description,
  });

  Future<void> addTask(Worker worker) async {
    final ref =
        FirestoreService().db.collection('workers').doc(worker.type.name);
    final w = await ref.get();

    if (w.exists) {
      return ref.update({
        'description': worker.description ?? taskDescription[worker.type.name],
        'specNames': FieldValue.arrayUnion(worker.specNames),
        'taskIds': FieldValue.arrayUnion(worker.taskIds),
      }).then((_) => Spectrum.registerWorker(worker, worker.specNames[0]));
    }

    return ref.set({
      'description': worker.description ?? taskDescription[worker.type.name],
      'specIds': worker.specNames,
      'taskIds': worker.taskIds,
    }).then((_) => Spectrum.registerWorker(worker, worker.specNames[0]));
  }

  Future<void> registerSpec(String specName, String worker) async {}
}

class Task {
  String? id; // auto generated doc id
  String type; // one of the task types
  String specName;
  Timestamp createdAt = Timestamp.now();
  Map<String, dynamic> data;
  // TODO: notification settings

  Task({
    this.id,
    required this.type,
    required this.specName,
    required this.data, // task data, e.g. a routine detail
  });

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'specName': specName,
      'createdAt': createdAt,
      'data': data,
    };
  }

  static Future<String> createTask(
      TaskType t, Map<String, dynamic> data) async {
    String taskId;

    switch (t) {
      case TaskType.routine:
        taskId = await createRoutine(t, Routine.fromMap(data));
        break;
    }

    return taskId;
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

Future<String> createRoutine(TaskType t, Routine r) async {
  var ref = FirestoreService().db.collection('tasks').doc();
  await ref.set({
    'type': t.name,
    'specName': r.specName,
    'data': r.asMap,
  });

  return ref.id;
}
