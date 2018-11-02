import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import './services.dart';
import './place_model.dart';
import './sub_model.dart';

class GlobalBloc {
  GlobalBloc() {
    _loadingSubject.sink.add(true);
    _ser.signInUserAnonymously().then(_sinkUser);
    _loadingSubject.sink.add(false);

    _ser.getAllPlaces().then(_sinkPlaces);
  }
  Services _ser = Services();

  BehaviorSubject<bool> _loadingSubject = BehaviorSubject<bool>();
  Stream<bool> get loading => _loadingSubject.stream;

  BehaviorSubject<FirebaseUser> _userSubject = BehaviorSubject<FirebaseUser>();
  Stream<FirebaseUser> get user => _userSubject.stream;

  BehaviorSubject<UnmodifiableListView<Place>> _placesSubject =
      BehaviorSubject<UnmodifiableListView<Place>>();
  Stream<UnmodifiableListView<Place>> get places => _placesSubject.stream;
  UnmodifiableListView<Place> get placesList => _placesSubject.value;

  BehaviorSubject<UnmodifiableListView<Sub>> _subSubject =
      BehaviorSubject<UnmodifiableListView<Sub>>();
  Stream<UnmodifiableListView<Sub>> get subs => _subSubject.stream;

  void _sinkUser(FirebaseUser user) {
    _userSubject.sink.add(user);
  }

  void _sinkPlaces(QuerySnapshot placesQuery) {
    List<Place> _ = [];
    placesQuery.documents.forEach((DocumentSnapshot placeDoc) =>
        _.add(Place.fromBloc(placeDoc.data, placeDoc.documentID)));
    _placesSubject.sink.add(UnmodifiableListView(_));
  }

  void getCurrentPlaceOrders(String uid) {
    _ser.getUsersOfPlace(uid).then((QuerySnapshot usersQuery) {
      usersQuery.documents.forEach((DocumentSnapshot userDoc) {
        getSubsOfUser(userDoc['phoneNumber']);
      });
    });
  }

  void getSubsOfUser(String phoneNumber) {
    List<Sub> _ = [];
    _ser.getSubsOfUser(phoneNumber).then((QuerySnapshot subsQuery) {
      subsQuery.documents.forEach((DocumentSnapshot subDoc) {
        _.add(Sub.fromBloc(subDoc.data));
      });
    });
    _subSubject.sink.add(UnmodifiableListView(_));
  }

  void dispose() {
    _loadingSubject.close();
    _userSubject.close();
    _placesSubject.close();
    _subSubject.close();
  }
}
