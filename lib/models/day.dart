import 'package:le_planning/models/unavailabilities.dart';

class Day {
  DateTime date;
  List<Unavailability> Unavailabilities;

  Day(this.date, this.Unavailabilities);
}
