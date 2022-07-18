import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spectrum/service/firestore.dart';

class User {
  final String id;
  String name;
  String _email;
  String? avatar;
  String? _password;
  String? bio;
  String? _pronoun;
  String? _birthday;
  String? _occupation;
  String? _nationality;
  List<String>? _specs;
  Map<String, dynamic>? _settings;

  User(
    this.id,
    this.name,
    this._email,
  );

  User.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null, "'id' cannot be null."),
        assert(map['name'] != null, "'name' cannot be null."),
        assert(map['email'] != null, "'email' cannot be null."),
        id = map['id'],
        name = map['name'],
        _email = map['email'],
        avatar = map['avatar'],
        _password = map['password'],
        bio = map['bio'],
        _pronoun = map['pronoun'],
        _birthday = map['birthday'],
        _occupation = map['occupation'],
        _nationality = map['nationality'],
        _specs = [],
        _settings = {};

  /// The current instance as a [Map].
  Map<String, dynamic> get asMap {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': _email,
      'avatar': avatar,
      'password': _password,
      'bio': bio,
      'pronoun': _pronoun,
      'birthday': _birthday,
      'occupation': _occupation,
      'nationality': _nationality,
      'specs': _specs ?? [],
      'settings': _settings,
    };
  }

  Future<bool> isNewUser(String id) async {
    var ref = FirestoreService().db.collection('users').doc(id);
    var snapshot = await ref.get();
    var data = snapshot.data();
    return data == null;
  }

  Future<void> createUser(User user) async {
    var ref = FirestoreService().db.collection('users').doc(user.id);
    return ref.set(user.asMap);
  }

  static Future<void> addSpec(String userId, String specName) async {
    var ref = FirestoreService().db.collection('users').doc(userId);
    return ref.update({
      'specs': FieldValue.arrayUnion([specName]),
    });
  }

  Future<void> updateUser(User user) async {}

  Future<void> deleteUser(User user) async {}
}
