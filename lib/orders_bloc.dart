import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import './services.dart';
import './sub_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersBloc {
  OrdersBloc(String uid) {
    getCurrentPlaceUsers(uid).then((QuerySnapshot q) => q.documents.forEach(
        (DocumentSnapshot doc) =>
            getSubsOfUser(doc.data['phoneNumber']).then((_) {
              // print(_subTempList);
              _subSubject.sink.add(UnmodifiableListView(_subTempList));
              print(_subSubject.value);
            })));
  }

  Services _ser = Services();

  BehaviorSubject<UnmodifiableListView<Sub>> _subSubject =
      BehaviorSubject<UnmodifiableListView<Sub>>();
  Stream<UnmodifiableListView<Sub>> get subs => _subSubject.stream;

  Future<QuerySnapshot> getCurrentPlaceUsers(String uid) async {
    return await _ser.getUsersOfPlace(uid);
  }

  List<Sub> _subTempList = [];
  Future<void> getSubsOfUser(String phoneNumber) async {
    QuerySnapshot q = await _ser.getSubsOfUser(phoneNumber);
    q.documents.forEach((DocumentSnapshot subDoc) {
      _subTempList.add(Sub.fromBloc(subDoc.data));
      // print(_subTempList);
    });
  }

  void dipose() {
    // _subSubject.close();
  }
}
