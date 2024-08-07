import 'package:flutter/material.dart';

class LoginScreenProvider extends ChangeNotifier{

  bool _isObsecure = true;

  bool get isObsecure => _isObsecure;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateObsecure (){
    _isObsecure = !_isObsecure;
    notifyListeners();
  }
  void updateProgressIndicator (bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
}