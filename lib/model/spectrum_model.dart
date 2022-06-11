import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectrum/service/firestore.dart';

class Spectrum {
  String? id; // firestore auto generated doc id
  String name; // enforces uniqueness in the form of '${spec.name}_$userId'
  bool? isDefault;
  String userId;
  bool isPublic = false;
  bool isArchived = false;
  bool isPinned = false;
  List<String>? workers; // this list holds the task types
  List<String>? tags;
  List<String>? taskIds;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  // TODO:
  // - add notification settings
  // - add attachments

  Spectrum({
    required this.name,
    required this.userId,
    this.isDefault,
    this.workers,
    this.taskIds,
    this.tags,
  });

  Spectrum.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['userId'] != null, "'userId' cannot be null."),
        name = map['name'],
        userId = map['userId'],
        isPinned = map['isPinned'] ?? false,
        // isDefault = map['isDefault'] ?? false,
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workers = map['workers'],
        tags = map['tags'],
        taskIds = map['taskIds'],
        createdAt = map['createdAt'] ?? FieldValue.serverTimestamp(),
        updatedAt = map['updatedAt'] ?? FieldValue.serverTimestamp();

  Spectrum.fromMapWithId(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['userId'] != null, "'userId' cannot be null."),
        name = map['name'],
        userId = map['userId'],
        id = map['id'],
        isPinned = map['isPinned'] ?? false,
        // isDefault = map['isDefault'] ?? false,
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workers = map['workers'],
        tags = map['tags'],
        taskIds = map['taskIds'],
        createdAt = map['createdAt'] ?? FieldValue.serverTimestamp(),
        updatedAt = map['updatedAt'] ?? FieldValue.serverTimestamp();

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'name': name,
      'userId': userId,
      'isPinned': isPinned,
      'isDefault': isDefault,
      'isPublic': isPublic,
      'isArchive': isArchived,
      'tags': tags,
      'workers': workers,
      'taskIds': taskIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> get asMapWithId {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userId': userId,
      'isPinned': isPinned,
      'isDefault': isDefault,
      'isPublic': isPublic,
      'isArchive': isArchived,
      'tags': tags,
      'workers': workers,
      'taskIds': taskIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Future<List<String>> fetchUserSpecNames(String userId) async {
    List<String> specNames = [];

    var userRef = FirestoreService().db.collection('users').doc(userId);
    var snapshot = await userRef.get();
    if (!snapshot.exists) return specNames;

    var data = snapshot.get('specs');
    data.forEach((specName) {
      specNames.add(specName);
    });
    return specNames;
  }

  static Future<List<Spectrum>> fetchAll(String userId) async {
    var ref = FirestoreService()
        .db
        .collection('specs')
        .where('userId', isEqualTo: userId);
    var data = await ref.get();

    if (data.size == 0) return [];
    return data.docs
        .map((doc) => Spectrum.fromMapWithId({'id': doc.id, ...doc.data()}))
        .toList();
  }

  static Future<Map<String, dynamic>> fetchSome(String userId, int cursor,
      String orderby, String orderDirection, int pageSize) async {
    var ref = FirestoreService()
        .db
        .collection('specs')
        .orderBy('userId')
        .orderBy(orderby, descending: orderDirection == 'desc')
        .startAt([userId]);

    var data = await ref.get();
    if (data.size == 0) return {'specs': [], 'hasMore': false};

    if (cursor + 1 >= data.size) {
      throw Exception('fetchSome: cursor out of range');
    }

    if (data.size < pageSize) pageSize = data.size;
    if (data.size - (cursor + 1) < pageSize) {
      pageSize = data.size - (cursor + 1);
    }

    int start = cursor + 1;
    int end = start + pageSize;

    var snapshot = data.docs.getRange(start, end).toList();
    var specs = snapshot
        .map((s) => Spectrum.fromMapWithId({'id': s.id, ...s.data()}))
        .toList();

    return {'specs': specs, 'hasMore': data.size > end};
  }

  static Future<List<Spectrum>> fetchByName(List<String> name) async {
    var ref =
        FirestoreService().db.collection('specs').where('name', whereIn: name);
    var data = await ref.get();

    if (data.size == 0) return [];
    return data.docs
        .map((doc) => Spectrum.fromMapWithId({'id': doc.id, ...doc.data()}))
        .toList();
  }

  static Future<Spectrum?> fetchDefault(String userId) async {
    var ref = FirestoreService()
        .db
        .collection('specs')
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true);
    var data = await ref.get();

    if (data.size == 0) return null;
    return Spectrum.fromMapWithId(
        {'id': data.docs.first.id, ...data.docs.first.data()});
  }

  static Future<String> createSpec(String userId, Spectrum spec,
      {bool isDefault = false}) async {
    var nameRef = FirestoreService()
        .db
        .collection('specs')
        .where('name', isEqualTo: '${spec.name}_$userId');
    var result = await nameRef.get();
    if (result.size > 0) {
      throw Exception('Spec name already exists.');
    }

    var ref = FirestoreService().db.collection('specs').doc();
    await FirestoreService().db.runTransaction((transaction) async {
      var s = spec.asMap;
      if (isDefault) s = {...s, 'isDefault': true};
      await ref.set(s);
      transaction
          .update(FirestoreService().db.collection('users').doc(userId), {
        'specs': FieldValue.arrayUnion(['${spec.name}_$userId'])
      });
    });

    return '${spec.name}_$userId';
  }

  // TODO:
  // - delete from spec collection
  // - related collection: users, workers, tasks
  static Future<void> delete(List<String> ids) async {}

  Future<void> registerWorker(String worker) async {}

  Future<void> update(String id, Spectrum spec) async {}
}
