import 'package:flutter/material.dart';


class HomePageAdminProvider extends ChangeNotifier{
  String _searchText = '';
  String get searchText => _searchText;

  void updateSearchText(String v){
    _searchText = v;
    notifyListeners();
  }

}