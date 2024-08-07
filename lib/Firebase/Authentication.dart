import 'package:asaanmakaan/Providers/AuthScreensProviders/LoginScreenProvider.dart';
import 'package:asaanmakaan/Providers/AuthScreensProviders/SignupScreenProvider.dart';
import 'package:asaanmakaan/Screens/Admin/HomePageAdmin.dart';
import 'package:asaanmakaan/Screens/CustomNavBar.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/Color.dart';
import '../Constants/FontSizes.dart';
import '../Screens/AuthScreens/Login.dart';
import '../Utils/Transitions.dart';

Future<String> signUp ({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required String phone,
  required BuildContext context
  })async{

    final provider = Provider.of<SignupScreenProvider>(context,listen: false);
    provider.updateProgressIndicator(true);
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value)async {
         try{
           await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).set({
             'email':email,
             'password':password,
             'uid':FirebaseAuth.instance.currentUser!.uid,
             'firstName':firstName,
             'lastName':lastName,
             'phone':phone
           }).then((value) {
             provider.updateProgressIndicator(false);
             navigateWithTransition(context, Login(), TransitionType.slideTopToBottom);
           });
         }
         catch(e){
           provider.updateProgressIndicator(false);
         }
      });
      return 'successful';
  }
  catch(e){
    provider.updateProgressIndicator(false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRubik('Error occurred!', white, FontWeight.w400, size12)));
    return 'unsuccessful';
  }
}

Future<String> login({required String email, required String password,required BuildContext context})async{

  final provider = Provider.of<LoginScreenProvider>(context,listen: false);

  try{
    provider.updateProgressIndicator(true);
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async{
      provider.updateProgressIndicator(false);
      if(email=='admin@admin.asaanmakaan.pk'){

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
      }else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CustomNavBar()));
      }
    });
    return 'successful';
  }
  catch(e){
    provider.updateProgressIndicator(false);
    return ('unsuccessful');
  }
}