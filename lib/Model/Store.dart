class StoreInfo{
  final String name;
  final String number;
  final String menu;

  StoreInfo(this.name, this.number, this.menu);

  factory StoreInfo.fromJson(Map<String, dynamic> json){
    return StoreInfo(json["name"], json['phone'], json['menu']);
  }
}

class StoreSearchInfo{
  final String name;
  final String menu;
  final double latitude;
  final double longitude;

  StoreSearchInfo(this.name, this.menu, this.latitude, this.longitude);

  factory StoreSearchInfo.fromJson(Map<String, dynamic> json){
    return StoreSearchInfo(json["name"], json['menu'], double.parse(json["latitude"].toString()), double.parse(json["longitude"].toString()));
  }
}