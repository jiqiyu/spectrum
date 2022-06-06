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
  List<String>? workders;
  List<String>? tags;
  List<String>? taskIds;
  Timestamp createdAt = Timestamp.now();
  Timestamp updatedAt = Timestamp.now();

  Spectrum(
    this.name,
    this.userId, [
    this.isDefault,
    this.workders,
    this.taskIds,
    this.tags,
  ]);

  Spectrum.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['userId'] != null, "'userId' cannot be null."),
        name = map['name'],
        userId = map['userId'],
        isDefault = map['isDefault'] ?? false,
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workders = map['workders'],
        tags = map['tags'],
        taskIds = map['taskIds'],
        createdAt = map['createdAt'] ?? Timestamp.now(),
        updatedAt = map['updatedAt'] ?? Timestamp.now();

  Spectrum.fromMapWithId(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        assert(map['userId'] != null, "'userId' cannot be null."),
        name = map['name'],
        userId = map['userId'],
        id = map['id'],
        isDefault = map['isDefault'] ?? false,
        isPublic = map['isPublic'] ?? false,
        isArchived = map['isArchived'] ?? false,
        workders = map['workders'],
        tags = map['tags'],
        taskIds = map['taskIds'],
        createdAt = map['createdAt'] ?? Timestamp.now(),
        updatedAt = map['updatedAt'] ?? Timestamp.now();

  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'name': name,
      'userId': userId,
      'isDefault': isDefault,
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
      'userId': userId,
      'isDefault': isDefault,
      'isPublic': isPublic,
      'isArchive': isArchived,
      'tags': tags,
      'workers': workders,
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

  static Future<String> createSpec(String userId, Spectrum spec) async {
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
      await ref.set(spec.asMap);
      transaction
          .update(FirestoreService().db.collection('users').doc(userId), {
        'specs': FieldValue.arrayUnion(['${spec.name}_$userId'])
      });
    });

    return '${spec.name}_$userId';
  }

  // TODO:
  // delete from spec collection and update other related collections
  static Future<void> delete(List<String> ids) async {}

  Future<void> registerWorker(String worker) async {}

  Future<void> update(String id, Spectrum spec) async {}
}
