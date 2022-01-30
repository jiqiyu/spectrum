import 'package:spectrum/service/firestore.dart';
import 'routine_model.dart';

class Worker {
  final TaskType type; // type.name is stored in firestore as document id
  List<String> specIds;
  List<String> taskIds;
  // TaskCreateFunction taskCreateFunction;
  String? description = '';

  Worker({
    required this.type,
    required this.specIds,
    required this.taskIds,
    // required this.taskCreateFunction,
    this.description,
  });

  Future<void> addWorker(Worker worker) async {
    var ref = FirestoreService().db.collection('tasks').doc(worker.type.name);
    return ref.set({
      'description': worker.description,
      'specIds': worker.specIds,
      'taskIds': worker.taskIds,
    });
  }

  Future<void> registerSpec(String specId, String worker) async {}
}

class Task {
  String? id;
  String type;
  String specId;
  DateTime createdAt = DateTime.now();
  Map<String, dynamic> data;

  Task({
    this.id,
    required this.type,
    required this.specId,
    required this.data,
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
  // stocktake,
  // startPoint,
  // endPoint,
  // singlePoint,
}

// typedef TaskCreateFunction = Future<void> Function(
//     TaskType taskType, Map<String, dynamic> map);

const Map<String, String> taskDescription = {
  'routine': 'cyclical, repeat periodically',
  'plan': 'short term or long term plan, e.g. 7 day plan, 30 day plan etc.',
};

// Future<void> createTask(TaskType t, Map<String, dynamic> map) async {
//     switch (t) {
//       case TaskType.routine:
//         await createRoutine(t, map as Routine);
//         break;
//     }
//   }

// Future<void> createRoutine(TaskType t, Routine r) async {
//   var ref = FirestoreService().db.collection('tasks').doc();
//   await ref.set({
//     'type': t.name,
//     'data': r.asMap,
//   });
// }