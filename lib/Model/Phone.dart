class PhoneNum{
  final String name;
  final String number;
  PhoneNum(this.name, this.number);

  factory PhoneNum.fromJson(Map<String, dynamic> json){
    return PhoneNum(json["name"], json['phone']);
  }
}