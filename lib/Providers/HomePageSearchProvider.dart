import 'package:flutter/material.dart';

class HomePageSearchProvider extends ChangeNotifier{

  String _buyRent = 'Buy';
  String _propertyType = 'Houses';

  String _housesSelected = 'Type';
  String _plotsSelected = 'Type';
  String _commercialSelected = 'Type';

  String _type = 'Houses';
  String _location = 'Lahore';
  String _areaSize = '5 Marla';

  String get type => _type;
  String get location => _location;
  String get areaSize => _areaSize;

  String get buyRent => _buyRent;
  String get propertyType => _propertyType;
  String get housesSelected => _housesSelected;
  String get plotsSelected => _plotsSelected;
  String get commercialSelected => _commercialSelected;

  List<String> keywordList = [];

  void updateType (String v){
    _type = v;
    notifyListeners();
  }

  void updateLocation (String v){
    _location = v;
    notifyListeners();
  }

  void updateAreaSize (String v){
    _areaSize = v;
    notifyListeners();
  }

  void updateBuyRent (String v){
    _buyRent = v;
    notifyListeners();
  }
  void updatePropertyType (String v){
    _propertyType = v;
    notifyListeners();
  }
  void updateHousesSelected (String v){
    _housesSelected = v;
    notifyListeners();
  }
  void updatePlotsSelected (String v){
    _plotsSelected = v;
    notifyListeners();
  }
  void updateCommercialSelected (String v){
    _commercialSelected = v;
    notifyListeners();
  }


}