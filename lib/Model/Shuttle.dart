class ShuttleStopDepartureInfo{
  final List<dynamic> shuttleListStation;
  final List<dynamic> shuttleListTerminal;
  final List<dynamic> shuttleListCycle;

  ShuttleStopDepartureInfo(this.shuttleListStation, this.shuttleListTerminal, this.shuttleListCycle);

  factory ShuttleStopDepartureInfo.fromJson(Map<String, dynamic> json){
    return ShuttleStopDepartureInfo(json["DH"], json["DY"], json["C"]);
  }
}

