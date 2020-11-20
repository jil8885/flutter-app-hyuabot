class ReadingRoomInfo{
  final int active;
  final int occupied;
  final int available;

  ReadingRoomInfo(this.active, this.occupied, this.available);

  factory ReadingRoomInfo.fromJson(Map<String, dynamic> json){
    return ReadingRoomInfo(json['active'], json['occupied'], json['available']);
  }
}