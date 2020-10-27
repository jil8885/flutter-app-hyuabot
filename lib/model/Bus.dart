class BusInfoRealtime{
  final int location;
  final int time;
  final int seats;

  BusInfoRealtime(this.location, this.time, this.seats);

  factory BusInfoRealtime.fromJson(Map<String, dynamic> json){
    return BusInfoRealtime(int.parse(json['location']), int.parse(json['time']), int.parse(json['seat']));
  }
}

class BusInfoTimetable{
  final String time;

  BusInfoTimetable(this.time);

  factory BusInfoTimetable.fromJson(Map<String, dynamic> json){
    return BusInfoTimetable(json['time']);
  }
}
