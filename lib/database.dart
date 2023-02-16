import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //Collection Reference - create or refer collection
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String userName, String emailId) async {
    return await usersCollection.doc(uid).set({
      'username': userName,
      'emailid': emailId,
    });
  }
}
