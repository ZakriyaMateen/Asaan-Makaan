import 'package:asaanmakaan/Screens/Admin/HomePageAdmin.dart';
import 'package:asaanmakaan/Screens/AuthScreens/Login.dart';
import 'package:asaanmakaan/Screens/CustomNavBar.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Providers/AuthScreensProviders/LoginWeb.dart';

class AnimateSplashScreenMobile extends StatefulWidget {
  const AnimateSplashScreenMobile({Key? key}) : super(key: key);

  @override
  State<AnimateSplashScreenMobile> createState() => _AnimateSplashScreenMobileState();
}

class _AnimateSplashScreenMobileState extends State<AnimateSplashScreenMobile> with SingleTickerProviderStateMixin {
  Color bgColor = Colors.white!;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    colorChange();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.9), end: Offset(0, 0)).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> colorChange() async {
    Future.delayed(Duration(milliseconds: 1300), () {
      screenTransition();
    });
  }

  Future<bool> doesPersist() async {
    try {
      if (await FirebaseAuth.instance.currentUser != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> isAdmin() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String currentUserUid = currentUser.uid;

        QuerySnapshot adminSnapshot = await FirebaseFirestore.instance.collection('Admin').limit(1).get();

        if (adminSnapshot.docs.isNotEmpty) {
          DocumentSnapshot adminDocument = adminSnapshot.docs.first;
          Map<String, dynamic> data = adminDocument.data() as Map<String, dynamic>;

          if (data.containsKey('uid') && data['uid'] == currentUserUid) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> screenTransition() async {
    bool persist = await doesPersist();
    bool admin = await isAdmin();

    Future.delayed(Duration(milliseconds: 1500), () {
      try {
        print('persist'+persist.toString());
        print('admin'+admin.toString());

        if (persist) {
          print('1');
          if (MediaQuery.of(context).size.width>700) {
            print('2');

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAdmin()));
          } else {
            print('3');

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomNavBar()));
          }
        }
        else if(!persist && MediaQuery.of(context).size.width>700){
          print('4');

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWeb()));
        }
        else {
          print('5');

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        }
      } catch (e) {
        if(MediaQuery.of(context).size.width>700){
          print('6');

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginWeb()));
        }
        else {
          print('7');

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
        }      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w < 550 ? 0 : w * 0.25, vertical: w < 550 ? 0 : h * 0.015),
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  alignment: Alignment.center,
                  child: Center(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: RotationTransition(
                            turns: _rotationAnimation,
                            child: Image.asset('assets/AsaanMakaanSplashScreen.png', height: 120, width: 120),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            textRubik('Asaan Makaan', Colors.black87, FontWeight.bold, 19),
          ],
        ),
      ),
    );
  }
}
