import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/Color.dart';
import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/SearchProvider.dart';
import '../../Utils/Text.dart';
import '../../Utils/Transitions.dart';
import 'ChatScreens/ChatScreen.dart';
import 'SelectedProperty.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h*0.06,),
            Row(
              children: [
              SizedBox(width: w*0.05 ,),   textLeftRubik('Favorites', darkTextColor, w600, size25),
              ],
            ),
            SizedBox(height: 20,),


            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites')
                    .orderBy('timestamp', descending: true) // Sort by 'createdAt' field in descending order
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(
                      child: CircularProgressIndicator(color: primaryColor,),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final docs = snapshot.data!.docs;
                      // Check if the property description contains any of the keywords

                    return
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index){
                            final data = docs[index].data();
                            return
                              InkWell(onTap: (){
                                try{
                                  navigateWithTransition(
                                      context, SelectedProperty(
                                    images: data['images']!=[]? data['images'] :[data['displayImage']],
                                    totalPrice: data['totalPrice'],
                                    posterUid: data['uid'],
                                    beds: data['bedrooms'],
                                    bathrooms: data['bathrooms'],
                                    area: data['area'],
                                    areaType: data['areaType'],
                                    description: data['propertyDescription'],
                                    title: data['propertyTitle'], timestamp: data['timestamp'], location: data['location'], docId: data['docId'], displayImage:  data['displayImage'],

                                  ), TransitionType.slideRightToLeft);

                                }
                                catch(e){
                                  print(e.toString());
                                }
                              },
                                child:
                                Container(
                                  color:white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        width: w,
                                        height: 150,
                                        decoration: BoxDecoration(
                                        color:white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: Image.network(data['displayImage'],width: 140,height: 150,fit: BoxFit.fill,),
                                            ),
                                            SizedBox(width: 6.5,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    textRubik(getTimeDifference(data['timestamp']), greyShade3, w400, size10),
                                                  ],
                                                ),
                                                SizedBox(height: 3,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    textRubik('PKR', darkTextColor, w500, size14),
                                                    SizedBox(width: 3,),
                                                    textRubik(data['totalPrice'], darkTextColor, w600, size18),
                                                  ],
                                                ),
                                                SizedBox(height: 3.5,),

                                                Container(
                                                  width: w-180,
                                                  alignment: AlignmentDirectional.centerStart,
                                                  child: textRobotoMessage(
                                                      (data['location'].toString()+ ', '+data['city'].toString()).toString().length<=29?
                                                      data['location'].toString()+ ', '+data['city'].toString():
                                                      (data['location'].toString()+ ', '+data['city'].toString()).substring(0,28)+'..', darkTextColor, w500, size15),
                                                ),

                                                SizedBox(height: 3.5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    textRubik(data['propertyTitle'], greyShade3, w400, size12),
                                                  ],
                                                ),
                                                SizedBox(height: 3.5,),
                                                Container(
                                                  width: w-140 - 8-8,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisSize: MainAxisSize.min ,
                                                        children: [
                                                          data['bedrooms']!='null'?  Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.bed,size: 15,color: darkTextColor,),
                                                              SizedBox(width: 3,),
                                                              textRubik(data['bedrooms'], darkTextColor, w500, size12),
                                                            ],
                                                          ):Container(),
                                                          SizedBox(width: 5,),
                                                          data['bedrooms']!='null'?Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.bathroom_outlined,size: 15,color: darkTextColor,),
                                                              SizedBox(width: 3,),
                                                              textRubik(data['bathrooms'], darkTextColor, w500, size12),
                                                            ],
                                                          ):Container(),
                                                          SizedBox(width: 5,),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.photo_size_select_small_sharp,size: 15,color: darkTextColor,),
                                                              SizedBox(width: 3,),
                                                              textRubik(
                                                                  data['area'].toString()+' '+data['areaType'].toString(),
                                                                  darkTextColor,
                                                                  w500,
                                                                  size12
                                                              ),


                                                            ],
                                                          ),
                                                          SizedBox(width: 5,),
                                                        ],
                                                      ),
                                                  InkWell(
                                                      onTap:()async{
                                                       try{
                                                         await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(data['docId']).delete();
                                                       }
                                                       catch(e){
                                                         print(e.toString());
                                                       }
                                                      },
                                                      child: Icon(Icons.favorite,color: red,size: 18,)
                                                  ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 7,),

                                                Container(
                                                  width: w-140 - 35,
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                        onTap:()async{
                                                          try{

                                                            try{
                                                              String phoneNumber = await data['phone'];

                                                              if (phoneNumber.isNotEmpty) {
                                                                String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp URL with phone number
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
                                                          }
                                                          catch(e){
                                                            print(e.toString());
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 38,
                                                          height: 35,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              color:primaryColor,
                                                              border: Border.all(color: primaryColor,width: 1),
                                                              borderRadius: BorderRadius.circular(8)
                                                          ),
                                                          child: Center(
                                                            child: Image.asset('assets/whatsapp.png',width: 16,height: 16,fit: BoxFit.cover,color: white,),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:()async{
                                                          try{
                                                            String phoneNumber = await data['phone'];

                                                            try{

                                                              if (phoneNumber.isNotEmpty) {
                                                                String phoneCallUrl = "tel:$phoneNumber"; // Phone call URL with phone number
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
                                                          width: 38,
                                                          height: 35,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: primaryColor,width: 1),
                                                              color:primaryColor,
                                                              borderRadius: BorderRadius.circular(8)

                                                          ),
                                                          child: Center(
                                                            child: Icon(Icons.call,color: white,),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:()async{
                                                          try {

                                                            String phoneNumber = await data['phone'];

                                                            if (phoneNumber.isNotEmpty) {
                                                              String smsUrl = "sms:$phoneNumber"; // SMS URL with phone number
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
                                                          width: 38,
                                                          height: 35,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: primaryColor,width: 1),
                                                              borderRadius: BorderRadius.circular(8)

                                                          ),
                                                          child: Center(
                                                            child:textRubik('SMS', primaryColor, w500, size14),
                                                          ),
                                                        ),
                                                      ),

                                                      InkWell(  onTap:(){
                                                        navigateWithTransition(context, ChatScreen(user2Uid: data['uid'],), TransitionType.slideRightToLeft);
                                                      },
                                                        child: Container(
                                                          width: 38,
                                                          height: 35,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(color: primaryColor,width: 1),
                                                              borderRadius: BorderRadius.circular(8)

                                                          ),
                                                          child: Center(

                                                              child:Icon(CupertinoIcons.chat_bubble_2,color: primaryColor,)
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5,),
                                      Divider(color: lightTextColor.withOpacity(0.3),thickness: 1,)
                                    ],
                                  ),
                                ),
                              );
                          },itemCount: docs.length);

                  }})


          ],
        ),
      ),
    );
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

}
