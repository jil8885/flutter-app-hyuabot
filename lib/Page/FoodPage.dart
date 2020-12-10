import 'package:flutter/material.dart';
import 'package:flutter_app_hyuabot_v2/Bloc/FoodController.dart';
import 'package:flutter_app_hyuabot_v2/Model/FoodMenu.dart';
import 'package:get/get.dart';

class FoodPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FoodPageState();
}

class FoodPageState extends State<FoodPage>{
  FetchFoodInfoController _foodInfoController;
  final  DateTime _now = DateTime.now();
  final Map<String, String> _cafeteriaList = {"학생식당": "student_erica", "교직원식당": "teacher_erica", "푸드코트": "food_court_erica", "창업보육센터": "changbo_erica", "창의인재원식당": "dorm_erica"};
  final Map<String, bool> _isExpanded = {"student_erica": false, "teacher_erica": false, "food_court_erica": false, "changbo_erica": false, "dorm_erica": false};

  Widget _foodItem(String menu, String price){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(menu, style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white,), textAlign: TextAlign.left,),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('$price 원', style: TextStyle(fontFamily: 'Godo', fontWeight: FontWeight.bold, color: Theme.of(context).backgroundColor == Colors.white ? Color.fromARGB(255, 20, 75, 170) : Colors.lightBlue),),
            ],
          )
        ],
      ),
    );
  }

  Widget _cafeteriaCard(Map<String, List<FoodMenu>> data, String name){
    String kind = "중식";
    List<FoodMenu> currentFood = [];
    if(_now.hour < 11 && data['breakfast'].isNotEmpty){
      currentFood = data['breakfast'];
      kind = "조식";
    } else if (_now.hour > 15 && data['dinner'].isNotEmpty){
      currentFood = data['dinner'];
      kind = "석식";
    } else if (data['lunch'].isNotEmpty){
      currentFood = data['lunch'];
    } else {
      currentFood = [];
    }

    List<Widget> currentFoodWidget;
    if(currentFood.isNotEmpty){
      currentFoodWidget = currentFood.map((e) => _foodItem(e.menu, e.price)).toList();
    } else {
      currentFoodWidget = [
        SizedBox(height: 10,),
        Container(child: Center(child: Text("식단이 제공되지 않습니다.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),),)
      ];
    }

    List<Widget> allFoodWidget = [];
    if(data['breakfast'].isNotEmpty){
      allFoodWidget.addAll([
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("조식", style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        )
      ]);
      allFoodWidget.addAll(data['breakfast'].map((e) => _foodItem(e.menu, e.price)).toList());
      allFoodWidget.add(Divider());
    }

    if(data['lunch'].isNotEmpty){
      allFoodWidget.addAll([
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("중식", style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        )
      ]);
      allFoodWidget.addAll(data['lunch'].map((e) => _foodItem(e.menu, e.price)).toList());
      allFoodWidget.add(Divider());
    }

    if(data['dinner'].isNotEmpty){
      allFoodWidget.addAll([
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("석식", style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        )
      ]);
      allFoodWidget.addAll(data['dinner'].map((e) => _foodItem(e.menu, e.price)).toList());
    }

    if(allFoodWidget.isNotEmpty && allFoodWidget[allFoodWidget.length - 1].runtimeType == Divider){
      allFoodWidget.removeLast();
    }

    if(allFoodWidget.isEmpty){
      allFoodWidget = [
        Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("중식", style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        SizedBox(height: 10,),
        Container(child: Center(child: Text("식단이 제공되지 않습니다.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),),)
      ];
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 3,
        color: Theme.of(context).backgroundColor == Colors.black ? Colors.black : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedCrossFade(
              crossFadeState: !_isExpanded[name] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: kThemeAnimationDuration,
              firstChild: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(kind, style: TextStyle(fontFamily: 'Godo', color: Theme.of(context).backgroundColor == Colors.white? Colors.black : Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: currentFoodWidget,
                  ),
                ],
              ),
              secondChild: Column(children: allFoodWidget,)
            ),
            InkWell(
              onTap: (){setState(() {_isExpanded[name] = !_isExpanded[name];});},
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: _isExpanded[name] ? Icon(Icons.keyboard_arrow_up_rounded):Icon(Icons.keyboard_arrow_down_rounded), onPressed: (){setState(() {_isExpanded[name] = !_isExpanded[name];});}),
                ],
              ),
            )
          ],
        )
      ),
    );
  }


  @override
  void initState() {
    _foodInfoController = FetchFoodInfoController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final TextStyle _theme1 = Theme.of(context).textTheme.bodyText1;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: StreamBuilder<Map<String, Map<String, List<FoodMenu>>>>(
            stream: _foodInfoController.allFoodInfo,
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child: Text("학식 정보를 불러오는데 실패했습니다.", style: Theme.of(context).textTheme.bodyText1,),);
              } else if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator(),);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).textTheme.bodyText1.color,), onPressed: (){Get.back();}, alignment: Alignment.centerLeft,),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text("학생식당", style: TextStyle(color: _theme1.color, fontSize: 20, fontFamily: 'Godo'), textAlign: TextAlign.center,)
                              ],
                            ),
                            _cafeteriaCard(snapshot.data[_cafeteriaList['학생식당']], _cafeteriaList['학생식당']),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("교직원식당", style: TextStyle(color: _theme1.color, fontSize: 20, fontFamily: 'Godo'), textAlign: TextAlign.center,)
                              ],
                            ),
                            _cafeteriaCard(snapshot.data[_cafeteriaList['교직원식당']], _cafeteriaList['교직원식당']),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("푸드코트", style: TextStyle(color: _theme1.color, fontSize: 20, fontFamily: 'Godo'), textAlign: TextAlign.center,)
                              ],
                            ),
                            _cafeteriaCard(snapshot.data[_cafeteriaList['푸드코트']], _cafeteriaList['푸드코트']),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("창업보육센터", style: TextStyle(color: _theme1.color, fontSize: 20, fontFamily: 'Godo'), textAlign: TextAlign.center,)
                              ],
                            ),
                            _cafeteriaCard(snapshot.data[_cafeteriaList['창업보육센터']], _cafeteriaList['창업보육센터']),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("창의인재원식당", style: TextStyle(color: _theme1.color, fontSize: 20, fontFamily: 'Godo'), textAlign: TextAlign.center,)
                              ],
                            ),
                            _cafeteriaCard(snapshot.data[_cafeteriaList['창의인재원식당']], _cafeteriaList['창의인재원식당']),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    _foodInfoController.dispose();
    super.dispose();
  }
}