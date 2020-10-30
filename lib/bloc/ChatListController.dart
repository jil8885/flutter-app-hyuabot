import 'package:chatbot/ui/ChatMessage.dart';
import 'package:rxdart/rxdart.dart';

class ChatListChanged{
  final _chatListSubject = BehaviorSubject<List<ChatMessage>>();
  ChatListChanged(){
    _chatListSubject.add([ChatMessage(text: "반갑하냥~내가 너를 도와줄게!")]);
  }

  void resetChatList(){
    _chatListSubject.add([ChatMessage(text: "반갑하냥~내가 너를 도와줄게!")]);
  }

  void setChatList(ChatMessage chatList){
    List<ChatMessage> _lastChatList = _chatListSubject.stream.value;
    _lastChatList.add(chatList);
    _chatListSubject.add(_lastChatList);
  }

  Stream<List<ChatMessage>> get chatList => _chatListSubject.stream;
}