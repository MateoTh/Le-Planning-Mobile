import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:le_planning/models/day.dart';
import 'package:le_planning/models/group.dart';
import 'package:le_planning/models/unavailabilities.dart';
import 'package:le_planning/repository/data_repository.dart';
import 'package:le_planning/shared/global_colors.dart';

class DetailGroup extends StatefulWidget {
  final User user;
  final Group group;
  const DetailGroup({super.key, required this.user, required this.group});

  @override
  State<DetailGroup> createState() => _DetailGroupState();
}

class _DetailGroupState extends State<DetailGroup> {
  getDaysInBetween() {
    final int difference =
        widget.group.startDate.difference(widget.group.endDate).inDays;
    return difference.abs();
  }

  @override
  Widget build(BuildContext context) {
    DataRepository repository = DataRepository();

    return StreamBuilder<QuerySnapshot>(
      stream: repository.groups
          .doc(widget.group.uid)
          .collection('unavailabilities')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        List<Unavailability> unavailabilities = snapshot.data!.docs
            .map((group) => Unavailability.fromSnapshot(group))
            .toList();
        final dates = List<DateTime>.generate(getDaysInBetween(), (i) {
          DateTime date = widget.group.startDate;
          return date.add(Duration(days: i));
        });
        List<Day> listDay = generateListDay(unavailabilities, dates);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: globalColorYellow,
            elevation: 0,
            title: const Text("Planning"),
            actions: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.edit),
                color: Colors.white,
              )
            ],
          ),
          body: ListView.builder(
              itemCount: listDay.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  tileColor: generateColor(
                      widget.group.users.length,
                      widget.group.users.length -
                          listDay[index].Unavailabilities.length),
                  title: Text(
                      '${listDay[index].date.day}/${listDay[index].date.month}/${listDay[index].date.year}'),
                  subtitle: Text(
                      "${widget.group.users.length - listDay[index].Unavailabilities.length}/${widget.group.users.length}"),
                  trailing: IconButton(
                    icon: Icon(listDay[index].Unavailabilities.any(
                            (unavailability) =>
                                unavailability.userUid == widget.user.uid)
                        ? Icons.check
                        : Icons.close),
                    onPressed: (() => {
                          // Si l'utilisateur a déja une indisponibilité à cette date
                          if (listDay[index].Unavailabilities.any(
                              (unavailability) =>
                                  unavailability.userUid == widget.user.uid))
                            {
                              repository
                                  .getUnavailabilitiesGroup(widget.group.uid)
                                  .doc(listDay[index]
                                      .Unavailabilities
                                      .firstWhere((unavailability) =>
                                          unavailability.userUid ==
                                          widget.user.uid)
                                      .uid)
                                  .delete()
                            }
                          else
                            {
                              repository.addUnavailability(widget.group.uid,
                                  widget.user.uid, listDay[index])
                            }
                        }),
                  ),
                );
              }),
        );
      },
    );
  }

  Color generateColor(num total, num presents) {
    var test = presents / total;
    if (test == 1) {
      return globalColorGreenGradiant;
    }
    if (test > 0.66) {
      return globalColorYellowGradiant;
    }
    if (test > 0.33) {
      return globalColorOrangeGradiant;
    }
    return globalColorRedGradiant;
  }

  List<Day> generateListDay(
      List<Unavailability> unavailabilities, List<DateTime> dates) {
    List<Day> listDays = [];
    for (var date in dates) {
      listDays.add(Day(
          date,
          unavailabilities
              .where((unavailability) =>
                  unavailability.date.day == date.day &&
                  unavailability.date.month == date.month &&
                  unavailability.date.year == date.year)
              .toList()));
    }
    return listDays;
  }
}
