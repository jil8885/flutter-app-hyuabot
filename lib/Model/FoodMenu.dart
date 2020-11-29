class FoodMenu{
  final String price;
  final String menu;
  FoodMenu(this.price, this.menu);

  factory FoodMenu.fromJson(Map<String, dynamic> json){
    return FoodMenu(json["price"], json['menu']);
  }
}

