class BusInfoRealtime{
  final int location;
  final int time;
  final int seats;

  BusInfoRealtime(this.location, this.time, this.seats);

  factory BusInfoRealtime.fromJson(Map<String, dynamic> json){
    return BusInfoRealtime(json['location'], json['time'], json['seat']);
  }
}

class BusInfoTimetable{
  final String time;

  BusInfoTimetable(this.time);

  factory BusInfoTimetable.fromJson(Map<String, dynamic> json){
    return BusInfoTimetable(json['time']);
  }
}
