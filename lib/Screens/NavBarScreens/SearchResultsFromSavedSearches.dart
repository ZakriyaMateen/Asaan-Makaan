import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Providers/SearchProvider.dart';
import 'package:asaanmakaan/Providers/SearchResultsProvider.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/SelectLocationSearch.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/SelectedProperty.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import 'ChatScreens/ChatScreen.dart';
import 'Search.dart';

class SearchResultsFromSavedSearches extends StatefulWidget {
  final String buyRent;
  final String selectedCity;
  final String searchTitle;
  final String homePlotCommercial;
  final String minRange;
  final String maxRange;
  final String minPrice;
  final String maxPrice;
  const SearchResultsFromSavedSearches({Key? key, required this.buyRent, required this.selectedCity, required this.searchTitle, required this.homePlotCommercial, required this.minRange, required this.maxRange, required this.minPrice, required this.maxPrice}) : super(key: key);

  @override
  State<SearchResultsFromSavedSearches> createState() => _SearchResultsFromSavedSearchesState();
}

class _SearchResultsFromSavedSearchesState extends State<SearchResultsFromSavedSearches> {


  List<Map<String,dynamic>> searchOptions = [
    {'iconData':Icons.filter_alt_sharp,'title':'Filters'},
    {'iconData':Icons.sort,'title':'Sort'},
    {'iconData':Icons.location_searching,'title':'Location'},
    {'iconData':Icons.price_check_rounded,'title':'Price Range'},
    {'iconData':Icons.area_chart_outlined,'title':'Area Range'},

  ];
  List<Map<String,dynamic>> sort = [
    {'iconData':Icons.star_border,'title':'Popular','isSelected':false},
    {'iconData':Icons.access_time_rounded,'title':'Newest','isSelected':true},
    {'iconData':Icons.keyboard_arrow_up_sharp,'title':'Price (low to high)','isSelected':false},
    {'iconData':Icons.keyboard_arrow_down_sharp,'title':'Price (hight to low)','isSelected':false},
  ];
  TextEditingController price1Controller = TextEditingController();
  TextEditingController price2Controller = TextEditingController();
  TextEditingController range1Controller = TextEditingController();
  TextEditingController range2Controller = TextEditingController();
  TextEditingController searchTitleController = TextEditingController();

  String price1 = '';
  String price2 = '';

  String range1 = '';
  String range2 = '';

  Future<void> getMyDetails()async{
    try{
      final provider = Provider.of<SearchResultsProvider>(context);
      DocumentSnapshot mySnap = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      List<dynamic> favourites =[];
      try{
        if(await mySnap['favouriteProperties']!=null){
          favourites = await mySnap['favouriteProperties'] ;
          print(provider.myFavouriteProperties);
        }
      }
      catch(e){
        print(e.toString()+' ths');
      }
      print(favourites);
      setState(() {
        provider.setMyFavouriteProperties(favourites);
      });
    }
    catch(e){
      print(e.toString());
    }
  }

  Future<void> init ()async{
    await getMyDetails();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    late var searchResProvider = Provider.of<SearchResultsProvider>(context,listen:false) ;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h*0.055,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w*0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        child: Icon(Icons.arrow_back_ios_new_outlined,color: white,),
                      ),
                    ),
                  ),

                  textLeftRubik(widget.searchTitle, darkTextColor, w600, size25),
                  Container(width: 35,),
                ],
              ),
            ),
            SizedBox(height: 15,),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(widget.selectedCity)
                    .doc(widget.homePlotCommercial == 'Houses' ? 'Homes' :
                widget.homePlotCommercial == 'Plots' ? 'Plots' : 'Commercial')
                    .collection(widget.homePlotCommercial == 'Houses' ? 'Homes' :
                widget.homePlotCommercial == 'Plots' ? 'Plots' : 'Commercial')
                    .doc(widget.buyRent)
                    .collection(widget.buyRent)
                    .orderBy('timestamp', descending: true) // Sort by 'createdAt' field in descending order
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final docs = snapshot.data!.docs;




                    return ListView.builder(itemBuilder: (context,index){
                      final data = docs[index].data();
                      return  InkWell(onTap: (){
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
                            title: data['propertyTitle'], timestamp: data['timestamp'], location: data['location'], docId: data['docId'], displayImage: data['displayImage'],

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
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            textRubik((data['location']+ ', '+data['city']).toString().length<=25?(data['location']+ ', '+data['city']):(data['location']+ ', '+data['city']).toString().substring(0,24)+'...', darkTextColor, w500, size15),
                                          ],
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
                                                          formatArea(convertArea(data['areaType'], data['area'], data['areaType'])) + ' ' + data['areaType'],
                                                          darkTextColor,
                                                          w500,
                                                          size12
                                                      ),


                                                    ],
                                                  ),
                                                  SizedBox(width: 5,),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8,),

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

                    },itemCount: docs.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);
                  }})
          ],
        ),
      ),
    );
  }

  Future<bool> checkIfDocumentExists( String uniqueFieldName, dynamic uniqueFieldValue) async {
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites')
        .where(uniqueFieldName, isEqualTo: uniqueFieldValue)
        .get();

    return result.docs.isNotEmpty;
  }

}
