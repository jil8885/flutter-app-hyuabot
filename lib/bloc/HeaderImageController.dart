import 'package:chatbot/config/common.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HeaderImageChanged{
  final _headerImageSubject = BehaviorSubject<Image>();
  HeaderImageChanged();

  void setHeaderImage(String imagePath){
    _headerImageSubject.add(Image.asset(imagePath));
  }

  Stream<Image> get headerImage => _headerImageSubject.stream;
}
