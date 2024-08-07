import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/ChatScreens/ChatScreen.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/SearchProvider.dart';
import 'MoreAdsFromAdvertiser.dart';

class SelectedProperty extends StatefulWidget {
  final List<dynamic> images;
  final String totalPrice;
  final String posterUid;
  final String beds;
  final String bathrooms;
  final String area;
  final String areaType;
  final String description;
  final String title;
  final String location;
  final Timestamp timestamp;
  final String docId;
  final String displayImage;
  const SelectedProperty({Key? key, required this.images, required this.totalPrice, required this.posterUid, required this.beds, required this.bathrooms, required this.area, required this.areaType, required this.description, required this.title, required this.timestamp, required this.location, required this.docId, required this.displayImage}) : super(key: key);

  @override
  State<SelectedProperty> createState() => _SelectedPropertyState();
}

class _SelectedPropertyState extends State<SelectedProperty> {

  bool favouriteTapped = false;
  int carouselIndex = 0;
  String getPriceSuffix(String totalPrice) {
    double? price = double.tryParse(totalPrice.replaceAll(',', ''));
    if (price != null) {
      if (price >= 10000000) {
        return ' Crore';
      } else if (price >= 100000) {
        return ' Lacs';
      } else {
        return ' Thousand';
      }
    } else {
      return '';
    }
  }
  String posterName = '';
  String posterImage = '';
  String posterPhone = '';
  String posterEmail = '';
  List<dynamic> myFavouriteProperties = [];

  Future<void> getMyDetails()async{
    try{
      DocumentSnapshot mySnap = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<dynamic> favourites =[];
     try{
       if(await mySnap['favouriteProperties']!=null){
         favourites = await mySnap['favouriteProperties'] ;
       }
     }
     catch(e){
       print(e.toString()+' ths');
     }
      // if(favourites.contains(widget.docId)){
      //   setState(() {
      //     favouriteTapped = true;
      //   });
      // }
      setState(() {
        myFavouriteProperties = favourites;
      });
    }
    catch(e){
      print(e.toString());
    }
  }
  List<dynamic> likedProperties = [];
  Future<void> getPosterDetails ()async{
    try{
      DocumentSnapshot posterSnap = await FirebaseFirestore.instance.collection('Users').doc(widget.posterUid).get();
      String name = await posterSnap['firstName']+' '+posterSnap['lastName'];
      String email = await posterSnap['email'];
      String phone = await posterSnap['phone'];
      String image = await posterSnap['imageUrl'];
      setState(() {
        posterName = name;
        posterEmail = email;
        posterPhone = phone;
        posterImage = image;
      });
      await getMyDetails();
    }
    catch(e){
      print(e.toString());
    }
  }
  void init ()async{
    await getPosterDetails();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final searchProvider = Provider.of<SearchProvider>(context,listen: false);


    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: w,
                  height: 320,
                  child: Stack(
                    children: [
                      CarouselSlider(
                      items: List.generate(widget.images.length==0?1:widget.images.length, (index) => Container(
                        width: w,
                        height: 320,
                        child: Image.network(widget.images.length==0?widget.displayImage:widget.images[index],fit: BoxFit.cover,),
                      )), options: CarouselOptions(
                            height: 320,
                          viewportFraction: 1,
                          enlargeCenterPage: false,
                          onPageChanged: (index,CarouselPageChangedReason pa){
                           if(index<6){
                             setState(() {
                               carouselIndex = index;
                             });
                           }
                          }
                      ),
                      ),
                      Align(alignment: Alignment.bottomCenter,child:
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Container(width: widget.images.length<=6?widget.images.length*2*7+14:100,height: 28,
                          decoration: BoxDecoration(
                            color: darkTextColor,
                            borderRadius: BorderRadius.circular(90),
                          ),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                List.generate(widget.images.length<=6?widget.images .length:6, (index)  {
                                  return Container(
                                    width: carouselIndex ==index ? 10:7,
                                    height: carouselIndex ==index ? 10:7,
                                    decoration: BoxDecoration(
                                      color: carouselIndex ==index ? white:greyShade4,
                                      shape: BoxShape.circle
                                    ),
                                  );
                                })
                              ,
                            ),
                          ),
                        )
                        ,)
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w*0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textRubik(searchProvider.propertyTypeSelected+' For Sale', lightTextColor.withOpacity(0.8), w400, size12),
                          textRubik(getTimeDifference(widget.timestamp), lightTextColor.withOpacity(0.8), w400, size12),
                        ],
                      ),
                      SizedBox(height: 9,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          textRubik('PKR ', darkTextColor, w500, size20),
                          textRubik(widget.totalPrice, darkTextColor, w500, size22),
                          textRubik(getPriceSuffix(widget.totalPrice), darkTextColor, w500, size22),
                        ],
                      ),

                      SizedBox(height: 9,),
                      Row(
                        children: [
                          textRubik(widget.location+ ', '+searchProvider.selectedCity, lightTextColor, w400, size13),
                        ],
                      ),
                      SizedBox(height: 11,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.area_chart_outlined,color: primaryColor,size: 22,),
                              SizedBox(width: 3,),
                              textRubik(widget.area+" "+widget.areaType, lightTextColor, w400, size15),
                            ],
                          ),
                        widget.bathrooms!='null'?  Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.bed,color: primaryColor,size: 22,),
                              SizedBox(width: 3,),
                              textRubik(widget.beds+' Beds', lightTextColor, w400, size15),
                            ],
                          ):Container(),
                          widget.bathrooms!='null'?  Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.bathroom_outlined,color: primaryColor,size: 22,),
                              SizedBox(width: 3,),
                              textRubik(widget.bathrooms+' Baths', lightTextColor, w400, size15),
                            ],
                          ):Container(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8,),
                Divider(thickness: 1, color: greyShade2,),
                SizedBox(height: 8,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w*0.05),
                  child: Column(
                    children: [
                      textLeftRubik(widget.title, darkTextColor.withOpacity(0.9), w400, size14),
                      SizedBox(height: 7,),
                      GestureDetector(
                        onTap: (){
                          showModalBottomSheet(context: context, builder: (context){
                            return Container(
                              width: w,
                              height: h*0.85,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 12,left: w*0.05,right: w*0.05),
                                    child:Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textRubik('Title and Description', darkTextColor,w500, size20),
                                        InkWell(
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Icons.close,size: 20,color: darkTextColor,))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12,),
                                  Divider(
                                    color: greyShade2,
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 12,),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: w*0.05),
                                    child: Column(
                                      children: [
                                        textLeftRubik(widget.title, darkTextColor, w500, size18),
                                        SizedBox(height: 10,),
                                        textLeftRubik(widget.description, lightTextColor, w400, size15)

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),),
                              backgroundColor: white);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            textRubik('Show Full Description', Colors.blue, w500, size12+0.5)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: w*0.9,
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!,width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 13),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: w*0.05,),
                              textLeftRubik('Ad Post By', lightTextColor.withOpacity(0.8), w500, size15),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: w*0.05,),
                              textLeftRubik(posterName, darkTextColor, w500, size16),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: greyShade2,width: 1)
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    //profileImage
                                    posterImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(thickness: 1,color: greyShade2,),
                          SizedBox(height: 10,),
                          InkWell(
                            onTap:(){
                              //Navigate to the poster's properties
                                                  navigateWithTransition(context, MoreAdsFromAdvertiser(uid: widget.posterUid),TransitionType.slideRightToLeft);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: w*0.05,),
                                textLeftRubik('View More Ads from this Advertiser ', lightTextColor, w400, size15),
                                Icon(Icons.open_in_new_rounded,color: primaryColor,size: size18,),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),


                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h*0.12,),
              ],
            ),
          ),
          Align(
             alignment: Alignment.bottomCenter,
            child: Container(
              width: w,
              color: white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(color: greyShade2,thickness: 1,),

                  Container(
                    width: w,
                    color: white,
                    padding: EdgeInsets.only(left: w*0.03,right: w*0.03,top: 5,bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:()async{
                            try {


                              if (posterPhone.isNotEmpty) {
                                String smsUrl = "sms:$posterPhone"; // SMS URL with phone number
                                if (await canLaunch(smsUrl)) {
                                  await launch(smsUrl);
                                } else {
                                  throw 'Could not launch $smsUrl';
                                }
                              } else {
                                throw 'Phone number is empty';
                              }
                            } catch(e) {
                              print(e.toString());
                            }
                          },
                          child: Container(
                            width: w*0.15,
                            height: 50,
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Icon(Icons.message,color: primaryColor,size: size25,),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            try {
                              if (posterEmail.isNotEmpty) {
                                String emailUrl = "mailto:$posterEmail"; // Email URL with email address
                                if (await canLaunch(emailUrl)) {
                                  await launch(emailUrl);
                                } else {
                                  throw 'Could not launch $emailUrl';
                                }
                              } else {
                                throw 'Email address is empty';
                              }
                            } catch(e) {
                              print(e.toString());
                            }
                          },

                          child: Container(
                            width: w*0.15,
                            height: 50,
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Icon(Icons.email,color: primaryColor,size: size25,),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap:()async{
                                  navigateWithTransition(context,ChatScreen(user2Uid: widget.posterUid),TransitionType.slideRightToLeft);
                          },
                          child: Container(
                            width: w*0.15,
                            height: 50,
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Icon(CupertinoIcons.chat_bubble_2,color: primaryColor,size: size25,),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap:()async{
                            try{

                              try{

                                if (posterPhone.isNotEmpty) {
                                  String phoneCallUrl = "tel:$posterPhone"; // Phone call URL with phone number
                                  if (await canLaunch(phoneCallUrl)) {
                                    await launch(phoneCallUrl);
                                  } else {
                                    throw 'Could not launch $phoneCallUrl';
                                  }
                                } else {
                                  throw 'Phone number is empty';
                                }
                              }
                              catch(e){
                                print(e.toString());
                              }
                            }
                            catch(e){
                              print(e.toString());
                            }
                          },
                          child: Container(
                            width: w*0.25,
                            height: 50,
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Icon(Icons.call,color: primaryColor,size: size25,),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap:()async{
                            try{

                              if (posterPhone.isNotEmpty) {
                                String whatsappUrl = "https://wa.me/$posterPhone"; // WhatsApp URL with phone number
                                if (await canLaunch(whatsappUrl)) {
                                  await launch(whatsappUrl);
                                } else {
                                  throw 'Could not launch $whatsappUrl';
                                }
                              }
                              else{
                                throw 'Phone number is empty';
                              }
                            }
                            catch(e){
                              print(e.toString());
                            }
                          },
                          child: Container(
                            width: w*0.15,
                            height: 50,
                            decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Image.asset('assets/whatsapp.png',width: 25,height: 25,fit: BoxFit.cover,color: primaryColor,)
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                  SizedBox(height: h*0.014,),
                ],
              ),
            ),
             ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: h*0.04,left: w*0.05,right: w*0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:(){
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: white,
                        shape: BoxShape.circle
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 4,),
                          Icon(Icons.arrow_back_ios,color: darkTextColor,size: 16,),
                        ],
                      ),
                    ),
                  ),

              // StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (
              // stream:
              // FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
              //
              // builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              // return  Center(
              // child: CircularProgressIndicator(color: primaryColor,),
              // );
              // } else if (snapshot.hasError) {
              // return Text('Error: ${snapshot.error}');
              // } else {
              // final docs1 = snapshot.data!.docs;
              // // Check if the property description contains any of the keywords
              // print(docs1[0]['favouriteProperties']);
              // return
              //   InkWell(
              //   onTap: ()async{
              //
              //     try{
              //      likedProperties = await docs1[0]['favouriteProperties'] as List<dynamic>;
              //
              //       if(likedProperties.contains(FirebaseAuth.instance.currentUser!.uid)){
              //         likedProperties.remove(FirebaseAuth.instance.currentUser!.uid);
              //         print(likedProperties);
              //         await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update(
              //             {
              //               'favouriteProperties':FieldValue.arrayUnion(likedProperties)
              //             });
              //       }
              //       else{
              //         likedProperties.add(FirebaseAuth.instance.currentUser!.uid);
              //         await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update(
              //             {
              //               'favouriteProperties':FieldValue.arrayUnion(likedProperties)
              //             });
              //       }
              //       setState(() {
              //         likedProperties = likedProperties;
              //       });
              //
              //     }
              //     catch(e){
              //       print(e.toString());
              //     }
              //
              //   },
              //   child: Container(
              //     width: 35,
              //     height: 35,
              //     decoration: BoxDecoration(
              //         color: white,
              //         shape: BoxShape.circle
              //     ),
              //     child: Center(
              //       child: Icon(Icons.favorite,color: likedProperties.contains(FirebaseAuth.instance.currentUser!.uid)?red:lightTextColor,size: 20,),
              //     ),
              //   ),
              // );
              // }})
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
