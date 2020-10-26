class ShuttleStopInfo{
  final List<dynamic> shuttleListStation;
  final List<dynamic> shuttleListTerminal;
  final List<dynamic> shuttleListCycle;

  ShuttleStopInfo(this.shuttleListStation, this.shuttleListTerminal, this.shuttleListCycle);
}

Map<String, ShuttleStopInfo> getShuttleList(Map<String, dynamic> json){
  Map<String, ShuttleStopInfo> shuttleInfoList = {};
  for(String key in json.keys){
    shuttleInfoList[key] = ShuttleStopInfo(json[key]['DH'], json[key]['DY'], json[key]['C']);
  }

  return shuttleInfoList;
}