import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final DocumentReference reference;
  final String name;

  User(this.name, {this.reference});

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  @override
  String toString() {
    return 'User{name: $name}';
  }
}
