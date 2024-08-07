import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/AddPost.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Favourites.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/MyProperties.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Search.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../Constants/Color.dart';
import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../AuthScreens/Login.dart';
import 'AddPost_navigated.dart';
import 'ProfileScreens/ContactUs.dart';
import 'ProfileScreens/FeedBack.dart';
import 'ProfileScreens/ProfileSettings.dart';
import 'ProfileScreens/TermsAndPrivacy.dart';
import 'SavedSearches.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: white.withOpacity(0.5),
      body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: w*0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h*0.06,),
                Row(
                  children: [
                    textLeftRubik('Profile', darkTextColor, w600, size25),
                  ],
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textRubik('Zakriya', darkTextColor, w500, size17),
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: Icon(CupertinoIcons.person,color: primaryColor,),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),

                InkWell(
                    onTap: (){
                      navigateWithTransition(context,ContactUs(),TransitionType.slideTopToBottom);
                    },
                    child: listTile(Icons.contact_support_outlined,'Contact Us')),
                InkWell(
                    onTap: (){
                      navigateWithTransition(context,FeedBack(),TransitionType.slideTopToBottom);

                    },
                    child: listTile(Icons.thumb_up_off_alt,'Feedback')),
                InkWell(
                    onTap: ()async{
                      try{
                         shareToWhatsApp('https://asaanmakaan.com');
                      }
                      catch(e){
                        print(e.toString());
                      }
                    },
                    child: listTile(Icons.attach_email_outlined,'Invite friends')),
                InkWell(
                    onTap: (){
                      navigateWithTransition(context,TermsAndPrivacy(),TransitionType.slideTopToBottom);

                    },
                    child: listTile(Icons.privacy_tip_outlined,'Terms and Privacy Policy')),
                InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context){
                        return Dialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: white,
                          child: Container(
                            width: w*0.8,
                            height: 150,
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textRobotoMessage('Sure you want to log out?',darkTextColor, w400, size18),
                                SizedBox(height: 10,),
                                Divider(
                                  thickness: 1,color: greyShade2,
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    InkWell(
                                        onTap:()async{
                                          await FirebaseAuth.instance.signOut().then((value) {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
                                          });
                                        },
                                        child: textRoboto('Confirm', red, w500, size20)),
                                    SizedBox(),
                                    InkWell(
                                        onTap:(){
                                          Navigator.pop(context);
                                        },
                                        child: textRoboto('Cancel', lightTextColor, w500, size20)),
                                    SizedBox(),

                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                    },
                    child: listTile(Icons.logout,'Log out')),
                listTile(Icons.info_outline,'App Version 1.0.5'),

                SizedBox(height: 10,),

                GridView.builder(
                  itemCount: options.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: (SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 8,mainAxisSpacing: 8)), itemBuilder: (context,index){
                  return InkWell(
                    onTap: index == 3?  (){
                          navigateWithTransition(context, MyProperties(),TransitionType.slideRightToLeft);
                    }:index == 2?  (){
                      navigateWithTransition(context, Favourites(),TransitionType.slideRightToLeft);

                    }:index == 1?  (){
                      navigateWithTransition(context, SavedSearches(),TransitionType.slideRightToLeft);
                    }:
                        index == 0? (){
                          navigateWithTransition(context, ProfileSettings(),TransitionType.slideRightToLeft);
                        }:
                        (){},
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: darkTextColor.withOpacity(0.2),spreadRadius: 1,),
                        ],
                      ),
                      alignment: AlignmentDirectional.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          WidgetAnimator(
                            atRestEffect: WidgetRestingEffects.bounce(delay: Duration(seconds: 3),numberOfPlays: 10),
                            incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
                            outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
                            child:Icon(options[index]['iconData'],color: darkTextColor.withOpacity(0.9),size: 25,),
                          ),
                          SizedBox(height: 5,),
                         textCenter(options[index]['title'], darkTextColor.withOpacity(0.9), w500, size16)
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 18,),
                Container(
                  width: w,
                  height: 150,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: darkTextColor.withOpacity(0.2),spreadRadius: 1,),
                    ],
                  ),
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 1,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/house.png',width: 80,height: 80,),
                          SizedBox(width: 8,),
                          Container(
                              width: w*0.6,
                              child:
                              TyperAnimatedTextKit(
                                // totalRepeatCount: 3,
                                speed: Duration(milliseconds: 150),
                                displayFullTextOnTap: true,
                                isRepeatingAnimation: true,
                                text: ['Sell or rent out your property?'],
                                textStyle: GoogleFonts.rubik(
                                  fontSize: size15,
                                  fontWeight: w500,
                                  color: darkTextColor,
                                ),
                              ),

                          )
                        ],
                      ),
                      InkWell(
                        onTap: (){
                          navigateWithTransition(context, AddPost_navigated(), TransitionType.slideRightToLeft);
                        },
                        child: Container(
                          width: w,
                          height: 43,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Center(
                            child: textRubik('Post Ad', primaryColor, w500, size15),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: h*0.045,),


              ],
            ),
          )
      ),
    );
  }
  void shareToWhatsApp(String link) async {
    final url = 'https://api.whatsapp.com/send?text=$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  List<Map<String,dynamic>> options = [
    {
      'iconData':Icons.settings_outlined,
      'title':'Profile Settings'
    },{
      'iconData':Icons.search_off_outlined,
      'title':'Saved Searched'
    },{
      'iconData':Icons.favorite_outline_rounded,
      'title':'My Favourites'
    },{
      'iconData':Icons.house_outlined,
      'title':'My Properties'
    }
  ];
  Widget listTile(IconData iconData,String title){
    return   Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(iconData,color: title=='Log Out'?red: darkTextColor.withOpacity(0.9),size: 20,),
          title: textRubik(title, title=='Log Out'?red:darkTextColor.withOpacity(0.9), w500, size17),
          trailing:Icon(Icons.arrow_forward_ios_outlined,color:  darkTextColor.withOpacity(0.9),size: 16,),
        ),
        Divider(color: darkTextColor.withOpacity(0.1),thickness: 1,)
      ],
    );
  }
}
