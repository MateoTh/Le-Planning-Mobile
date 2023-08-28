import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:le_planning/models/day.dart';
import 'package:le_planning/repository/request_result.dart';
import 'dart:math' as math;

import '../models/group.dart';

class GroupRepository {
  final CollectionReference groups =
      FirebaseFirestore.instance.collection('group');

  Stream<QuerySnapshot> getGroupstream() {
    return groups.snapshots();
  }

  Future<Group?> getGroupByJoinCode(String joinCode, String uidUser) async {
    QuerySnapshot snapshot =
        await groups.where('joinCode', isEqualTo: joinCode).get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot groupDoc = snapshot.docs[0];
      return Group.fromSnapshot(groupDoc);
    }

    return null;
  }

  CollectionReference getUnavailabilitiesGroup(String uidGroup) {
    return FirebaseFirestore.instance
        .collection('group')
        .doc(uidGroup)
        .collection('unavailabilities');
  }

  void addGroup(Group group) {
    var milliseconds = DateTime.now().microsecondsSinceEpoch.toString();
    var joinCode = milliseconds.substring(milliseconds.length - 6);

    var newGroup = {
      'name': group.name,
      'color': (math.Random().nextDouble() * 0xFFFFFF).toInt() + 0xFF000000,
      'joinCode': joinCode,
      'description': group.description,
      'startDate': group.startDate,
      'endDate': group.endDate,
      'users': group.users,
      'ownerUid': group.ownerUid
    };

    groups.add(newGroup).then((DocumentReference groupRef) {
      var unavailabilitiesCollection = groupRef.collection('unavailabilities');

      for (var unavailability in group.unavailabilities) {
        unavailabilitiesCollection
            .add({
              'unavailability': unavailability,
            })
            .then((DocumentReference unavailabilityRef) {})
            .catchError((error) {});
      }
    }).catchError((error) {});
  }

  Future<RequestResult> joinGroup(String uidGroup, String uidUser) async {
    DocumentSnapshot snapshot = await groups.doc(uidGroup).get();

    if (!snapshot.exists) {
      return RequestResult(
          false, 'No group found', 'Aucun groupe ne corresponds à ce code');
    }

    Map<String, dynamic> groupData = snapshot.data() as Map<String, dynamic>;
    List<String> usersList = List<String>.from(groupData['users'] ?? []);

    if (usersList.contains(uidUser)) {
      return RequestResult(false, 'User already in this group',
          'Tu appartiens déja au groupe ' + groupData['name']);
    }
    usersList.add(uidUser);

    await groups.doc(snapshot.id).update({'users': usersList});

    return RequestResult.withoutMessages(true);
  }

  void addUnavailability(String uidGroup, String uidUser, Day unavailability) {
    getUnavailabilitiesGroup(uidGroup).add({
      'date':
          "${unavailability.date.year}-${unavailability.date.month.toString().padLeft(2, '0')}-${unavailability.date.day.toString().padLeft(2, '0')}",
      'userUid': uidUser,
    }).catchError((error) {});
    ;
  }
}
