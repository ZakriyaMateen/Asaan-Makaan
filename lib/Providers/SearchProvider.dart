
import 'package:asaanmakaan/Constants/AreasOfPakistan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier{

  bool _switchVal = false;
  bool get switchVal => _switchVal;

  //change it to true, false
  List<bool> _buyRent = [false,true];
  List<bool> get buyRent => _buyRent;

  void updateBuyRent(int index,bool v){
    _buyRent[index] = v;
    notifyListeners();
  }

  String _selectedLocation = '';
  List<String> _filteredLocations = areasOfPakistan;

  String get selectedLocation => _selectedLocation;

  void clearSelectedLocation(){
    _selectedLocation = '';
    notifyListeners();
  }

  set selectedLocation(String value) {
    _selectedLocation = value;
    notifyListeners();
  }

  List<String> get filteredLocations => _filteredLocations;

  void filterLocations(String query) {
    _filteredLocations = areasOfPakistan
        .where((location) =>
        location.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  bool validateLocation(String value) {
    return areasOfPakistan.contains(value);
  }



  void updateSwitchVal (bool v){
    _switchVal = v;
    notifyListeners();
  }


  String _propertyTypeSelected = 'Houses';
  String _housesSelected = 'All';
  String _plotsSelected = 'All';
  String _commercialSelected = 'All';
  String _areaType = 'Marla';
  String _bedroom = '';
  String _bathroom = '';
  String _selectedCity = 'Lahore';
  String _citySearchText = '';
  String _minPrice = '';
  String _maxPrice = '';
  String _minArea = '';
  String _maxArea = '';

  String get minArea => _minArea;
  String get maxArea => _maxArea;

  String get minPrice => _minPrice;
  String get maxPrice => _maxPrice;

  void updateMinArea(String v){
    _minArea = v;
    notifyListeners();
  }
  void updateMaxArea(String v){
    _maxArea = v;
    notifyListeners();
  }

  void updateMinPrice (String v){
    _minPrice = v;
    notifyListeners();
  }
  void updateMaxPrice(String v){
    _maxPrice = v;
    notifyListeners();
  }


  String get propertyTypeSelected => _propertyTypeSelected;
  String get housesSelected => _housesSelected;
  String get plotsSelected => _plotsSelected;
  String get commercialSelected => _commercialSelected;
  String get areaType => _areaType;
  String get bedroom  => _bedroom;
  String get bathroom => _bathroom;
  String get selectedCity => _selectedCity;
  String get citySearchText => _citySearchText;

  List<String> _keywordList = [];

  List<String> get keywordList => _keywordList;

  void addToKeywordList (String v){
    _keywordList.add(v);
    notifyListeners();
  }
  void removeFromKeywordList (String index){
    _keywordList.remove(index);
    notifyListeners();
  }
  void clearKeywordList (){
    _keywordList.clear();
    notifyListeners();
  }

  void updateCitySearchText(String v){
    _citySearchText = v;
    notifyListeners();
  }

  void updateSelectedCity (String v){
    _selectedCity = v;
    notifyListeners();
  }

  void updatePropertyTypeSelected(String v){
    _propertyTypeSelected = v;
    notifyListeners();
  }
  void updateHousesSelected(String v){
    _housesSelected = v;
    notifyListeners();
  }

  void updatePlotsSelected(String v){
    _plotsSelected = v;
    notifyListeners();
  }
  void updateCommercialSelected(String v){
    _commercialSelected = v;
    notifyListeners();
  }
  void updateAreaType(String v){
    _areaType = v;
    notifyListeners();
  }
  void updateBedroom(String v){
    _bedroom = v;
    notifyListeners();
  }
  void updateBathroom(String v){
    _bathroom = v;
    notifyListeners();
  }

}

String getTimeDifference(Timestamp timestamp) {
  DateTime docTime = timestamp.toDate();
  DateTime now = DateTime.now();
  Duration difference = now.difference(docTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return 'Just now';
  }
}
double convertArea(String fromUnit, String area, String toUnit) {
  double areaValue = double.parse(area);
  double areaInSqFt;

  // Convert the input area to Sq ft
  switch (fromUnit) {
    case 'Marla':
      areaInSqFt = areaValue * 272.25;
      break;
    case 'Sq. Ft.':
      areaInSqFt = areaValue;
      break;
    case 'Sq. Yd.':
      areaInSqFt = areaValue * 9; // 1 Sq. Yd = 9 Sq ft
      break;
    case 'Kanal':
      areaInSqFt = areaValue * 5445;
      break;
    default:
      throw ArgumentError('Invalid fromUnit');
  }

  // Convert the area in Sq ft to the desired unit
  double convertedArea;
  switch (toUnit) {
    case 'Marla':
      convertedArea = areaInSqFt / 272.25;
      break;
    case 'Sq. Ft.':
      convertedArea = areaInSqFt;
      break;
    case 'Sq. Yd.':
      convertedArea = areaInSqFt / 9;
      break;
    case 'Kanal':
      convertedArea = areaInSqFt / 5445;
      break;
    default:
      throw ArgumentError('Invalid toUnit');
  }

  return convertedArea;
}

String formatArea(double area) {
  if (area == area.roundToDouble()) {
    return area.toStringAsFixed(0); // No decimals
  } else {
    return area.toStringAsFixed(1).replaceFirst(RegExp(r'0*$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}