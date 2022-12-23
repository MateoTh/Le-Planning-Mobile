import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:le_planning/models/unavailabilities.dart';

class Group {
  String uid;
  String name = 'Name';
  String description = 'Description';
  String ownerUid = 'Uid';
  DateTime endDate;
  DateTime startDate;
  List<String> users;
  List<Unavailability> unavailabilities;

  Group(this.uid, this.name, this.description, this.ownerUid, this.startDate,
      this.endDate, this.users, this.unavailabilities);

  factory Group.fromJson(Map<String, dynamic> json, String id) =>
      groupFromJson(json, id);
  factory Group.fromSnapshot(DocumentSnapshot snapshot) {
    return Group.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
  }
}

Group groupFromJson(Map<String, dynamic> json, String id) {
  return Group(
      id,
      json["name"] as String,
      json["description"] as String,
      json["ownerUid"] as String,
      json["startDate"].toDate() as DateTime,
      json["endDate"].toDate() as DateTime,
      json['users'].map<String>((i) => i as String).toList(),
      List<Unavailability>.from(json["unavailabilities"] != null
          ? json["unavailabilities"]
                  .map((model) => Unavailability.fromJson(model, ''))
              as List<Unavailability>
          : []));
}

Map<String, dynamic> groupToJson(Group instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'users': instance.users
    };
