import 'package:cloud_firestore/cloud_firestore.dart';

class Unavailability {
  String uid;
  DateTime date;
  String userUid = 'userUid';

  Unavailability(this.uid, this.date, this.userUid);

  factory Unavailability.fromJson(Map<String, dynamic> json, String id) =>
      unavailabilityFromJson(json, id);
  factory Unavailability.fromSnapshot(DocumentSnapshot snapshot) {
    return Unavailability.fromJson(
        snapshot.data() as Map<String, dynamic>, snapshot.id);
  }
}

Unavailability unavailabilityFromJson(Map<String, dynamic> json, String id) {
  return Unavailability(
      id, DateTime.parse(json["date"]), json["userUid"] as String);
}

Map<String, dynamic> unavailabilityToJson(Unavailability instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'userUid': instance.userUid,
    };
