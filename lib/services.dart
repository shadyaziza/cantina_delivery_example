import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Services {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> signInUserAnonymously() async =>
      await _auth.signInAnonymously();

  Future<QuerySnapshot> getAllPlaces() async =>
      await Firestore.instance.collection('places').getDocuments();

  Future<QuerySnapshot> getUsersOfPlace(String uid) async =>
      await Firestore.instance
          .collection('users')
          .where('place', isEqualTo: uid)
          .getDocuments();

Future<QuerySnapshot> getSubsOfUser(String phoneNumber)async=>await Firestore.instance
          .collection('tempSubs')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .getDocuments();
}
