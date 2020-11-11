import 'package:chatbot/config/networking.dart' as conf;
import 'package:chatbot/model/FoodMenu.dart';
import 'package:chatbot/ui/ChatMessage.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatListChanged{
  final _chatListSubject = BehaviorSubject<List<ChatMessage>>();
  ChatListChanged(BuildContext context){
    _chatListSubject.add([ChatMessage(chat: Text("반갑하냥~내가 너를 도와줄게!", style: Theme.of(context).textTheme.bodyText2),)]);
  }

  void resetChatList(BuildContext context){
    _chatListSubject.add([ChatMessage(chat: Text("반갑하냥~내가 너를 도와줄게!", style: Theme.of(context).textTheme.bodyText2),)]);
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

    if(menuResult.keys.length == 0){
      setChatList(ChatMessage(chat: Text("오늘 준비된 메뉴가 없다냥 ㅠㅠ", style: Theme.of(context).textTheme.bodyText2),));
    }
    List<String> kinds = menuResult.keys.toList();
    Widget foodMsg = ListView.separated(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: menuResult.keys.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          child: Text(kinds[index]),
        );
      },
      separatorBuilder: (context, index){
        return Divider(color: Theme.of(context).textTheme.bodyText1.color,);
      },
    );

    List<ChatMessage> _lastChatList = _chatListSubject.stream.value;
    if(_lastChatList.last.chat.runtimeType == ListView){
      _lastChatList.removeLast();
    }
    _lastChatList.add(ChatMessage(chat: foodMsg,));
    _chatListSubject.add(_lastChatList);
  }

  Stream<List<ChatMessage>> get chatList => _chatListSubject.stream;
}