import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectrum/service/firestore.dart';

class Spectrum {
  String? id; // firestore auto generated doc id
  String name; // enforces uniqueness in the form of '${spec.name}_$userId'
  bool? isDefault;
  bool isPublic = false;
  bool isArchived = false;
  List<String>? workders = [];
  List<String>? tags = [];
  List<String>? taskIds = [];
  Timestamp createdAt = Timestamp.now();
  Timestamp updatedAt = Timestamp.now();

  Spectrum(
    this.name, [
    this.isDefault,
    this.workders,
    this.taskIds,
    this.tags,
  ]);

  Spectrum.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null, "'name' cannot be null."),
        name = map['name'],
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
        id = map['id'],
        name = map['name'],
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

  static Future<List<String>> fetchUserSpecIds(String userId) async {
    List<String> specIds = [];

    var userRef = FirestoreService().db.collection('users').doc(userId);
    var snapshot = await userRef.get();
    if (!snapshot.exists) return specIds;

    var data = snapshot.get('specs');
    data.forEach((specId) {
      specIds.add(specId);
    });
    return specIds;
  }

  static Future<List<Spectrum>> fetchAll(String userId) async {
    var specIds = await fetchUserSpecIds(userId);
    if (specIds.isEmpty) return [];

    var ref = FirestoreService()
        .db
        .collection('specs')
        .where(FieldPath.documentId, whereIn: specIds);
    var data = await ref.get();

    if (data.size == 0) return [];
    return data.docs
        .map((doc) => Spectrum.fromMapWithId({'id': doc.id, ...doc.data()}))
        .toList();
  }

  static Future<List<Spectrum>> fetchSome(String userId, String cursor,
      String orderby, String orderDirection, int pageSize) async {
    var specIds = await fetchUserSpecIds(userId);
    specIds.sort();
    if (specIds.isEmpty) return [];

    var ref = FirestoreService()
        .db
        .collection('specs')
        .where(FieldPath.documentId, whereIn: specIds)
        .orderBy(FieldPath.documentId)
        // TODO: fix this
        .startAt(cursor == '' ? [specIds[0]] : [cursor])
        .limit(pageSize);

    var data = await ref.get();
    if (data.size == 0) return [];

    var snapshot = data.docs.toList();
    var specs = snapshot
        .map((s) => Spectrum.fromMapWithId({'id': s.id, ...s.data()}))
        .toList();

    switch (orderby) {
      case 'name':
        specs.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'updatedAt':
        specs.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      default:
        specs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    if (orderDirection == 'desc') specs.reversed.toList();

    return specs;
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
        'specs': FieldValue.arrayUnion([ref.id])
      });
    });

    return ref.id;
  }

  // TODO: delete from spec collection and update other related collections
  static Future<void> delete(String id) async {}

  Future<void> registerWorker(String worker) async {}

  Future<void> update(String id, Spectrum spec) async {}
}
