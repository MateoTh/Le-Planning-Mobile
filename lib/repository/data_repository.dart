import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:le_planning/models/day.dart';

class DataRepository {
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('group');

  CollectionReference getUnavailabilitiesGroup(String uidGroup) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(uidGroup)
        .collection('unavailabilities');
  }

  Stream<QuerySnapshot> getGroupstream() {
    return groups.snapshots();
  }

  void addUnavailability(String uidGroup, String uidUser, Day unavailability) {
    getUnavailabilitiesGroup(uidGroup).add({
      'date':
          "${unavailability.date.year}-${unavailability.date.month.toString().padLeft(2, '0')}-${unavailability.date.day.toString().padLeft(2, '0')}",
      'userUid': uidUser,
    });
  }
}
