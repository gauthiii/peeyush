import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String mobile;
  final String name;

  User({
    this.email,
    this.mobile,
    this.name,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      email: doc['id'],
      mobile: doc['mobile'],
      name: doc['name'],
    );
  }
}
