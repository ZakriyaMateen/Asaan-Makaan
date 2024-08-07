import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Screens/AuthScreens/Login.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/AddPost.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Favourites.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Profile.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/ProfileScreens/ContactUs.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/ProfileScreens/TermsAndPrivacy.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Search.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/FontSizes.dart';
import '../Constants/FontWeights.dart';
import '../Utils/Transitions.dart';
import 'NavBarScreens/HomePage.dart';
import 'NavBarScreens/ProfileScreens/FeedBack.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  List<Widget> screens = [
    HomePage(),
    Search(),
    AddPost(),
    Favourites(),
    Profile(),
  ];
  int selectedIndex = 0 ;
  Widget divider(){
    return
      Divider(thickness: 1,color: greyShade2,);
  }
  Widget tile(IconData iconData, String title){
    return    ListTile(
      leading: Icon(iconData,color: lightTextColor,size: size19,),
      title: textRubik(title,lightTextColor, w400, size17),
    );
  }
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: w*0.75,
        height: h,
        color: white,
        padding: EdgeInsets.only(top: h*0.05,left: w*0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textRubik('Asaan Makaan', primaryColor, w600, size20),
              SizedBox(height: 15,),
              // textRubik('Zaki', darkTextColor, w400, size15),
              InkWell(
                onTap: (){
                  setState(() {
                    selectedIndex = 4;
                  });
                  Navigator.pop(context);
                },
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textRubik('View Profile ', primaryColor, w400, size15),
                  Icon(Icons.arrow_forward,color: primaryColor,size: size17,)
                ],),
              ),
              SizedBox(height: 10,),
              divider(),
              SizedBox(height: 10,),
              InkWell(
                  onTap: (){
                    setState(() {
                      selectedIndex = 0;
                    });
                    Navigator.pop(context);
                  },
                  child: tile(Icons.home_outlined, 'Home')),
              InkWell(
                  onTap: (){
                    setState(() {
                      selectedIndex = 2;
                    });
                    Navigator.pop(context);
                  },
                  child: tile(Icons.add, 'Add Property')),
              InkWell(
                  onTap: (){
                    setState(() {
                      selectedIndex = 1;
                    });
                    Navigator.pop(context);
                  },
                  child: tile(Icons.search, 'Search Properties')),
              InkWell(
                  onTap: (){
                    launchUrl(Uri.parse('https://blogspot.com'));
                  },
                  child: tile(Icons.comment_bank_outlined, 'Asaan Makaan Blogs')),
              InkWell(
                  onTap:(){
                    setState(() {
                      selectedIndex = 3;
                    });
                    Navigator.pop(context);
                  },
                  child: tile(Icons.favorite_outline_rounded, 'Favorites')),
              SizedBox(height: 10,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: divider(),),
                  textRubik(' Controls ', greyShade3, w400, size15),
                  Flexible(child: divider(),),
                ],
              ),
              SizedBox(height: 10,),
              InkWell(
                  onTap: (){
                    navigateWithTransition(context, TermsAndPrivacy(), TransitionType.slideTopToBottom);
                  },
                  child: tile(Icons.info_outline, 'About Us')),
              InkWell(
                  onTap: (){
                    navigateWithTransition(context, ContactUs(), TransitionType.slideTopToBottom);
                  },
                  child: tile(Icons.contact_support, 'Contact Us')),
              InkWell(   onTap: (){
                navigateWithTransition(context, FeedBack(), TransitionType.slideTopToBottom);
              },child: tile(Icons.feedback_outlined, 'Feedback')),
              InkWell(   onTap: (){
                navigateWithTransition(context, TermsAndPrivacy(), TransitionType.slideTopToBottom);
              },child: tile(Icons.privacy_tip_outlined, 'Terms & Privacy Policy')),
              InkWell(
                  onTap: ()async{
                  try{
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                  }catch(e){

                  }
                  },
                  child: tile(Icons.logout, 'Logout')),
            ],
          ),
        ),
      ),
      backgroundColor: white,
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: white,
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkTextColor,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (index){
          index!=1?  setState(() {
            selectedIndex = index;
          }):(){};
          index == 1?
          navigateWithTransition(context, Search(), TransitionType.slideRightToLeft):null;

          },
        currentIndex: selectedIndex,

        items: [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_alt),activeIcon: Icon(CupertinoIcons.house_alt_fill),label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.search_off_outlined),activeIcon: Icon(Icons.search_off),label: ''),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.add_circled),activeIcon: Icon(CupertinoIcons.add_circled_solid),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline_rounded),activeIcon: Icon(Icons.favorite_rounded),label: ''),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.person),activeIcon: Icon(CupertinoIcons.person_fill),label: ''),
      ],

      ) ,
    );
  }
}
//