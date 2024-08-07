import 'dart:io';

import 'package:flutter/material.dart';

import '../Constants/AreasOfPakistan.dart';

class AddPostProvider extends ChangeNotifier{

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  String _formattedAmount = '';
  String get formattedAmount => _formattedAmount;
  void formatAmount(String value) {
    if (value.isEmpty) {

        _formattedAmount = '';
        notifyListeners();
        return;
    }

    int amount = int.tryParse(value.replaceAll(',', '')) ?? 0;

    if (amount >= 100000) {
        _formattedAmount = _getFormattedAmount(amount);
        notifyListeners();
    } else {
        _formattedAmount = '';
        notifyListeners();
    }
  }

  String _getFormattedAmount(int amount) {
    if (amount >= 10000000) {
      double croreValue = amount / 10000000;
      return '${croreValue.toStringAsFixed(croreValue.truncateToDouble() == croreValue ? 0 : 2)} Crore';
    } else if (amount >= 100000) {
      double lakhValue = amount / 100000;
      return '${lakhValue.toStringAsFixed(lakhValue.truncateToDouble() == lakhValue ? 0 : 2)} Lac';
    }
    return '';
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


  void updateIsSuccess(bool v){
    _isSuccess = v;
    notifyListeners();
  }

  bool _isUploading = false;
  bool get isUploading => _isUploading;



  void updateIsUploading(bool v){
    _isUploading = v;
    notifyListeners();
  }

  //File
  List<File> _images = [];
  List<File> get images => _images;

  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  void addImageUrls(String url){
    _imageUrls.add(url);
    notifyListeners();
  }
  void addImages(var v){
    _images.add(v);
    notifyListeners();
  }
  void removeImages(int index){
    _images.removeAt(index);
    notifyListeners();
  }

  //
  //bool
  bool _possessionSwitchVal = false;
  bool get possessionSwitchVal => _possessionSwitchVal;

  void updatePossessionSwitchVal(v){
    _possessionSwitchVal = v;
    notifyListeners();
  }
  //
  //Strings
  String _citySearchText = '';
  String _purposeOptionSelected = 'Sell';
  String _propertyTypeOption = 'Homes';
  String _bathroom = '1';
  String _bedroom = 'Studio';
  String _areaType = 'Sq. Ft.';
  String _propertyTypeOptionHomesSelected = 'House';
  String _propertyTypeOptionPlotsSelected = 'Residential Plot';
  String _propertyTypeOptionCommercialSelected = 'Office';
  String _selectedCity = 'Lahore';
//
  //get Strings
  String get citySearchText =>_citySearchText;
  String get purposeOptionSelected => _purposeOptionSelected;
  String get propertyTypeOption => _propertyTypeOption;
  String get bathroom => _bathroom;
  String get bedroom => _bedroom;
  String get areaType => _areaType;
  String get propertyTypeOptionHomesSelected => _propertyTypeOptionHomesSelected ;
  String get propertyTypeOptionPlotsSelected => _propertyTypeOptionPlotsSelected ;
  String get propertyTypeOptionCommercialSelected => _propertyTypeOptionCommercialSelected;
  String get selectedCity => _selectedCity;
  //
  void resetAll(){
     _citySearchText = '';
     _purposeOptionSelected = 'Sell';
     _propertyTypeOption = 'Homes';
     _bathroom = '1';
     _bedroom = 'Studio';
     _areaType = 'Sq. Ft.';
     _propertyTypeOptionHomesSelected = 'House';
     _propertyTypeOptionPlotsSelected = 'Residential Plot';
     _propertyTypeOptionCommercialSelected = 'Office';
     _selectedCity = 'Lahore';

    notifyListeners();
  }
  void updateCitySearchText (String v){
    _citySearchText = v;
    notifyListeners();
  }
  void updatePurposeOptionSelected (String v){
    _purposeOptionSelected = v;
    notifyListeners();
  }
  void updatePropertyTypeOption (String v){
    _propertyTypeOption = v;
    notifyListeners();
  }
  void updateBathroom (String v){
    _bathroom = v;
    notifyListeners();
  }
  void updateBedroom (String v){
    _bedroom = v;
    notifyListeners();
  }
  void updateAreaType (String v){
    _areaType = v;
    notifyListeners();
  }
  void updatePropertyTypeOptionHomesSelected (String v){
    _propertyTypeOptionHomesSelected = v;
    notifyListeners();
  }
  void updatePropertyTypeOptionPlotsSelected (String v){
    _propertyTypeOptionPlotsSelected = v;
    notifyListeners();
  }
  void updatePropertyTypeOptionCommercialSelected (String v){
    _propertyTypeOptionCommercialSelected = v;
    notifyListeners();
  }
  void updateSelectedCity (String v){
    _selectedCity = v;
    notifyListeners();
  }

}