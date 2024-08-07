import 'package:flutter/material.dart';

class SearchResultsProvider extends ChangeNotifier{

  List<dynamic> _myFavouriteProperties = [];
  List<dynamic> get myFavouriteProperties => _myFavouriteProperties;

  void setMyFavouriteProperties(List v){
    _myFavouriteProperties = v;
    notifyListeners();
  }

  void addToMyFavouriteProperties (String v){
    _myFavouriteProperties.add(v);
    notifyListeners();
  }
  void removeFromMyFavouriteProperties (String v){
    _myFavouriteProperties.remove(v);
    notifyListeners();
  }

}