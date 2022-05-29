import 'dart:async';
import 'package:spectrum/service/firestore.dart';

class Spectrum {
  String? id; // firestore auto generated doc id
  String name; // enforces uniqueness
  bool isPublic = false;
  bool isArchived = false;
  List<String>? workders = [];
  List<String>? tags = [];
  List<String>? taskIds = [];
  final DateTime createdAt = DateTime.now();
  DateTime? updatedAt;

  Spectrum(
    this.name, [
    this.workders,
    this.taskIds,
    this.tags,
  ]);

  Spectrum.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        name = map['name'],
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workders = List<String>.from(map['workders'] ?? []),
        tags = List<String>.from(map['tags'] ?? []),
        taskIds = List<String>.from(map['taskIds'] ?? []),
        updatedAt = map['updatedAt'];

  Spectrum.fromMapWithId(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        id = map['id'],
        name = map['name'],
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workders = List<String>.from(map['workders'] ?? []),
        tags = List<String>.from(map['tags'] ?? []),
        taskIds = List<String>.from(map['taskIds'] ?? []),
        updatedAt = map['updatedAt'];

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'name': name,
      'isPublic': isPublic,
      'isArchive': isArchived,
      'tags': tags,
      'workers': workders,
      'taskIds': taskIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> get asMapWithId {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'isPublic': isPublic,
      'isArchive': isArchived,
      'tags': tags,
      'workers': workders,
      'taskIds': taskIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Future<List<Spectrum>> fetchAll() async {
    var ref = FirestoreService().db.collection('specs');
    var snapshot = await ref.get();
    if (snapshot.size == 0) return [];
    var data = snapshot.docs.map((s) => s.data());
    List<Spectrum> specs = data.map((d) => Spectrum.fromMapWithId(d)).toList();
    return specs;
  }

  Future<void> createSpec(Spectrum spec, [bool isDefault = false]) async {
    var nameRef = FirestoreService()
        .db
        .collection('specs')
        .doc(isDefault ? 'system_default' : spec.name);
    var result = await nameRef.get();
    if (result.exists) {
      throw Exception('Spec name already exists.');
    }

    var ref = isDefault
        ? FirestoreService().db.collection('specs').doc('system_default')
        : FirestoreService().db.collection('specs').doc();
    await ref.set(spec.asMap);
  }

  Future<void> delete(String id) async {}

  Future<void> registerWorker(String worker) async {}

  Future<void> update(String id, Spectrum spec) async {}
}
