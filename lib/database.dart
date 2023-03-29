import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Future<String?> addUser({
    required String uid,
    required String phonenum,
  }) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(uid).set({
        'userID': uid,
        'phoneNum': phonenum,
        'guardian1': "No data yet!",
        'guardian2': "No data yet!",
        'guardian3': "No data yet!",
        'lat1': "28.7041",
        'lon1': "77.1025",
        'lat2': "19.0760",
        'lon2': "72.8777",
      }, SetOptions(merge: true));

      return "success";
    } catch (e) {
      return "error";
    }
  }

  Future<Map> getUser(String uid) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      final snapshot = await usersCollection.doc(uid).get();
      return snapshot.data() as Map<dynamic, dynamic>;
    } catch (e) {
      return {'result': "error"};
    }
  }

  Future<String?> addSafePoint1({
    required String uid,
    required String lat1,
    required String lon1,
  }) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(uid).set({
        'userID': uid,
        'lat1': lat1,
        'lon1': lon1,
      }, SetOptions(merge: true));

      return "success";
    } catch (e) {
      return "error";
    }
  }

  Future<String?> addSafePoint2({
    required String uid,
    required String lat2,
    required String lon2,
  }) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(uid).set({
        'userID': uid,
        'lat2': lat2,
        'lon2': lon2,
      }, SetOptions(merge: true));

      return "success";
    } catch (e) {
      return "error";
    }
  }

  Future<String?> addGuardians({
    required String uid,
    required String field,
    required String value,
  }) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      await usersCollection.doc(uid).set({
        'userID': uid,
        field: value,
      }, SetOptions(merge: true));

      return "success";
    } catch (e) {
      return "error";
    }
  }
}
