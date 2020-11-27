import 'package:chatbot/config/Localization.dart';
import 'package:chatbot/config/Networking.dart' as conf;
import 'package:chatbot/model/FoodMenu.dart';
import 'package:chatbot/ui/ChatMessage.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatListChanged{
  final _chatListSubject = BehaviorSubject<List<ChatMessage>>();
  ChatListChanged(BuildContext context){
    _chatListSubject.add([ChatMessage(chat: Text(Translations.of(context).trans("hello_msg"), style: Theme.of(context).textTheme.bodyText2),)]);
  }

  void resetChatList(BuildContext context){
    _chatListSubject.add([ChatMessage(chat: Text(Translations.of(context).trans("hello_msg"), style: Theme.of(context).textTheme.bodyText2),)]);
  }

  void setChatList(ChatMessage chatList){
    List<ChatMessage> _lastChatList = _chatListSubject.stream.value;
    _lastChatList.add(chatList);
    _chatListSubject.add(_lastChatList);
  }

  void fetchMenu(String restaurant, BuildContext context) async{
    final url = Uri.encodeFull(conf.getAPIServer() + "/app/food");
    http.Response response = await http.post(url, headers: {"Accept": "application/json"}, body: jsonEncode({"campus": "ERICA", "restaurant": restaurant}));
    Map<String, dynamic> responseJson = jsonDecode(utf8.decode(response.bodyBytes));

    Map<String, List<FoodMenu>> menuResult = {};
    for(String key in responseJson.keys){
      if(key.contains("식")){
        menuResult[key] = (responseJson[key] as List).map((e) => FoodMenu.fromJson(e)).toList();
      }
    }

    List<ChatMessage> _lastChatList = _chatListSubject.stream.value;
    if(_lastChatList.last.chat.runtimeType == Column || (_lastChatList.last.chat.runtimeType == Text && _lastChatList.length > 2)){
      _lastChatList.removeLast();
    }

    if(menuResult.keys.length == 0){
      _lastChatList.add(ChatMessage(chat: Text("오늘 준비된 메뉴가 없다냥 ㅠㅠ", style: Theme.of(context).textTheme.bodyText2),));
      _chatListSubject.add(_lastChatList);
      return;
    }
    List<String> kinds = menuResult.keys.toList();
    List<String> sortedKind = [];
    if(kinds.contains("조식")){
      sortedKind.add("조식");
      kinds.remove("조식");
    }
    
    if(kinds.contains("중식")){
      sortedKind.add("중식");
      kinds.remove("중식");
    }
    
    if(kinds.contains("석식")){
      sortedKind.add("석식");
      kinds.remove("석식");
    }

    sortedKind.addAll(kinds);
    Map<String, List<Widget>> menuWidget = {};
    List<Widget> listWidget;
    for(String key in sortedKind){
      listWidget = [];
      for(FoodMenu menu in menuResult[key]){
        listWidget.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(menu.menu, style: Theme.of(context).textTheme.bodyText2,),
              Text('${menu.price}원', style: TextStyle(color: Colors.white), textAlign: TextAlign.left,)
          ],)
        );
      }
      menuWidget[key] = listWidget;
    }

    Widget foodMsg = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          padding: const EdgeInsets.all(2),
          shrinkWrap: true,
          itemCount: sortedKind.length,
          itemBuilder: (BuildContext context, int index){
          return ConfigurableExpansionTile(
            animatedWidgetFollowingHeader: const Icon(
              Icons.expand_more,
              color: const Color(0xFF707070),
            ),
            initiallyExpanded: true,
            header: Text(sortedKind[index], style: Theme.of(context).textTheme.bodyText2,),
            children: menuWidget[sortedKind[index]],
          );
        },
        separatorBuilder: (context, index){
          return Divider(color: Theme.of(context).textTheme.bodyText1.color,);
        },
      )],
    );

    _lastChatList.add(ChatMessage(chat: foodMsg,));
    _chatListSubject.add(_lastChatList);
    return;
  }

  Stream<List<ChatMessage>> get chatList => _chatListSubject.stream;
}