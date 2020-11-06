class MetroRealtimeInfo{
  final terminalStation;
  final currentStation;
  final remainedTime;
  final currentStatus;

  MetroRealtimeInfo(this.terminalStation, this.currentStation, this.remainedTime, this.currentStatus);

  factory MetroRealtimeInfo.fromJson(Map<String, dynamic> json){
    return MetroRealtimeInfo(json["terminalStn"], json["pos"], json["time"], json['status']);
  }
}

class MetroTimeTableInfo{
  final terminalStation;
  final arrivalTime;


  MetroTimeTableInfo(this.terminalStation, this.arrivalTime);

  factory MetroTimeTableInfo.fromJson(Map<String, dynamic> json){
    return MetroTimeTableInfo(json["terminalStn"], json['time']);
  }
}

