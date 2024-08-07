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

class MyProperties extends StatefulWidget {
  const MyProperties({Key? key}) : super(key: key);

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  bool isDeleting = false;
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
                SizedBox(width: w*0.05,),
                InkWell(
                  onTap: (){Navigator.pop(context);},
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                        color: darkTextColor,
                        shape: BoxShape.circle
                    ),
                    child: Center(
                      child: Icon(Icons.arrow_back_ios_new_outlined,color: white,size: size12,),
                    ),
                  ),
                ),SizedBox(width: 15,),
                SizedBox(width: w*0.05 ,),
                textLeftRubik('My Properties', darkTextColor, w600, size22),
              ],
            ),

            SizedBox(height: 20,),

            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('MyProperties')
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
                              GestureDetector(
                                onLongPress: ()async{
                                  showDialog(context: context, builder: (context){
                                    return StatefulBuilder(
                                      builder: (BuildContext context,  StateSetter setstate) {
                                        return  Dialog(

                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          backgroundColor: white,
                                          child:
                                          Container(
                                            width: 150,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                color: white,
                                                borderRadius: BorderRadius.circular(12)
                                            ),
                                            alignment: AlignmentDirectional.center,
                                            child: isDeleting?Center(child: CircularProgressIndicator(color:primaryColor),): Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                                  child: textCenter('Delete this property?', darkTextColor, w500, size18),
                                                ),
                                                SizedBox(height: 8,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                        onTap:()async{
                                                          try{
                                                            setstate(() {
                                                              isDeleting = true;
                                                            });
                                                          await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('MyProperties').doc(data['docId']).delete().then((value) async{
                                                            try{
                                                              await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection(data['city']).doc(data['propertyTypeOption']).collection(data['propertyTypeOption']).doc(data['purpose']).delete().then((value) {
                                                                setstate((){
                                                                  isDeleting = false;
                                                                });
                                                                Navigator.pop(context);
                                                              });
                                                            }
                                                            catch(e){
                                                              setstate((){
                                                                isDeleting = false;
                                                              });
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Some error occurred!',white, w400, size16)));
                                                              Navigator.pop(context);
                                                            }
                                                          });


                                                          }catch(e){
                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Could not delete, please try again later!',white, w400, size16)));
                                                            setstate(() {
                                                              isDeleting = false;
                                                            });
                                                            Navigator.pop(context);

                                                            print(e.toString());
                                                          }
                                                        },
                                                        child: textCenter('Confirm', red, w400, size15)),
                                                    SizedBox(width: 8,),
                                                    textCenter('|', lightTextColor, w400, size15),
                                                    SizedBox(width: 8,),
                                                    InkWell(
                                                        onTap:(){Navigator.pop(context);},
                                                        child: textCenter('Cancel', darkTextColor, w400, size15)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },);
                                },
                                onTap: (){
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
                                        height: 150, decoration: BoxDecoration(
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
                                                SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    textRubik('PKR', darkTextColor, w500, size14),
                                                    SizedBox(width: 3,),
                                                    textRubik(data['totalPrice'], darkTextColor, w600, size18),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Container(
                                                  width: w-180,
                                                  alignment: AlignmentDirectional.centerStart,

                                                  child: textRobotoMessage(
                                                      (data['location'].toString()+ ', '+data['city'].toString()).toString().length<=50?
                                                      data['location'].toString()+ ', '+data['city'].toString():
                                                      (data['location'].toString()+ ', '+data['city'].toString()).substring(0,49)+'..', darkTextColor, w500, size15),
                                                ),
                                                SizedBox(height: 5,),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    textRubik(data['propertyTitle'], greyShade3, w400, size12),
                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                Container( width: w-140 - 8-8,
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
                                                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                                          stream:
                                                          FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').where('docId',isEqualTo:data['docId']).snapshots(),

                                                          builder: (context, snapshot) {
                                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                                              return  Center(
                                                                child: CircularProgressIndicator(color: primaryColor,),
                                                              );
                                                            } else if (snapshot.hasError) {
                                                              return Text('Error: ${snapshot.error}');
                                                            } else {
                                                              final docs1 = snapshot.data!.docs;
                                                              // Check if the property description contains any of the keywords
                                                              return
                                                                docs1.length==0?
                                                                InkWell(
                                                                    onTap:()async{
                                                                      try{
                                                                        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs [index]['docId']).set({
                                                                          'city':data['city'],
                                                                          'propertyType':data['propertyType'],
                                                                          'purpose':data['purpose'],
                                                                          'docId':data['docId'],
                                                                          'images':data['images'],
                                                                          'displayImage':data['displayImage'],
                                                                          'totalPrice':data['totalPrice'],
                                                                          'location':data['location'],
                                                                          'area':data['area'],
                                                                          'areaType':data['areaType'],
                                                                          'bathrooms':data['bathrooms'],
                                                                          'bedrooms':data['bedrooms'],
                                                                          'propertyDescription':data['propertyDescription'],
                                                                          'propertyTitle':data['propertyTitle'],
                                                                          'timestamp':data['timestamp'],
                                                                          'readyForPossession':data['readyForPossession'],
                                                                          'uid':data['uid'],
                                                                          'likedBy':data['likedBy'],
                                                                        });
                                                                      }
                                                                      catch(e){
                                                                        print(e.toString());
                                                                      }
                                                                    },
                                                                    child: Icon(Icons.favorite,color: lightTextColor,size: 18,)
                                                                ):
                                                                InkWell(
                                                                    onTap:()async{
                                                                      try{
                                                                        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                                                                      }
                                                                      catch(e){
                                                                        print(e.toString());
                                                                      }
                                                                    },
                                                                    child: Icon(Icons.favorite,color: red,size: 18,)
                                                                );
                                                            }}),

                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 8,),

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
