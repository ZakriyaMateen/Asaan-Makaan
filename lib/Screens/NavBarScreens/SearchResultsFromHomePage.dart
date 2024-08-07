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
import '../../Providers/HomePageSearchProvider.dart';
import 'ChatScreens/ChatScreen.dart';
import 'Search.dart';

class SearchResultsFromHomePage extends StatefulWidget {


  const SearchResultsFromHomePage({Key? key}) : super(key: key);

  @override
  State<SearchResultsFromHomePage> createState() => _SearchResultsFromHomePageState();
}

class _SearchResultsFromHomePageState extends State<SearchResultsFromHomePage> {


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
  String getSubstring(String input) {
    // Check if the input contains ' Marla' or ' Kanal'
    if (input.contains(' Marla')) {
      // If ' Marla' is found, extract substring excluding it
      return input.substring(0, input.indexOf(' Marla'));
    } else if (input.contains(' Kanal')) {
      // If ' Kanal' is found, extract substring excluding it
      return input.substring(0, input.indexOf(' Kanal'));
    } else {
      // If neither ' Marla' nor ' Kanal' is found, return the input as it is
      return input;
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final searchProvider = Provider.of<HomePageSearchProvider>(context,listen: false);


    print(searchProvider.buyRent);
    print(searchProvider.propertyType);

    print(searchProvider.housesSelected);
    print(searchProvider.plotsSelected);
    print(searchProvider.commercialSelected);

    print(searchProvider.location);

    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h*0.04,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w*0.055),
              child: Row(
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
                        child: Icon(Icons.arrow_back_ios_new_outlined,color: white,size: size12,),
                      ),
                    ),
                  ),SizedBox(width: 15,),
                  SizedBox(width: w*0.05 ,),   textLeftRubik('Search Results', darkTextColor, w600, size25),
                ],
              ),
            ),
            SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection(searchProvider.location)
                    .doc(searchProvider.propertyType == 'Houses' ? 'Homes' :
                searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial')
                    .collection(searchProvider.propertyType == 'Houses' ? 'Homes' :
                searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial')
                    .doc(searchProvider.buyRent=='Buy'?'Sell':searchProvider.buyRent)
                    .collection(searchProvider.buyRent=='Buy'?'Sell':searchProvider.buyRent)
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
                    final rootDocs = snapshot.data!.docs;
                    // var docs = rootDocs.where((doc) {
                    //   var data = doc.data() as Map<String, dynamic>;
                    //
                    //   // Check if the property description contains any of the keywords
                    //
                    //
                    //   double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], 'Marla')) );
                    //   if( searchProvider.propertyType == 'Houses'){
                    //     if ( searchProvider.propertyType == 'Houses') {
                    //       return
                    //           (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                    //               ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize))));;
                    //
                    //     } else {
                    //       return
                    //
                    //           (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                    //               ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize)))); ;
                    //     }
                    //   }
                    //   else   if (searchProvider.propertyType == 'Plots'){
                    //
                    //     if (searchProvider.propertyType == 'Plots') {
                    //       return
                    //             (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial'])  &&
                    //             ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize))));;
                    //
                    //     } else {
                    //       return
                    //             (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial'])  &&
                    //             ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize))));
                    //     }
                    //   }
                    //   else{
                    //     if (  searchProvider.propertyType == 'Plots') {
                    //       return
                    //
                    //             (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                    //       ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize))));
                    //
                    //     } else {
                    //
                    //       return
                    //             (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                    //             ((searchProvider.areaSize.isEmpty || areaDocument >= double.parse(getSubstring(searchProvider.areaSize))));
                    //     }
                    //   }
                    //
                    // }).toList();



                    // homesPlotsCommercial


                    final docs =

                    rootDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final homesPlotsCommercial = data['homesPlotsCommercial'];
                      final city = data['city'];
                      final area = data['area'];

                     String homePlotsCommercialSelected = searchProvider.type;
                      if(homePlotsCommercialSelected == 'Houses'){
                        homePlotsCommercialSelected = 'House';
                      }

                      print('homesPlotsCommercial   :   ' +homesPlotsCommercial);
                      print('homePlotsCommercialSelected   :   ' +homePlotsCommercialSelected);


                      List<String> parts = searchProvider.areaSize.split(' ');

                      // Take the first part, which should be the number
                      String number = parts[0];
                        print(number);
                        print('areaSize   : '+area !);
                        print('city : '+city!);
                      return
                        homesPlotsCommercial == homePlotsCommercialSelected &&
                         city == searchProvider.location &&
                           area == number;

                    }).toList();


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
                                                                  (data['area']+' '+ data['areaType'] ).toString().length<=30?
                                                                  (data['area']+' '+ data['areaType'] ).toString():
                                                                  (data['area']+' '+ data['areaType'] ).toString().substring(0,29),
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
                                                                        List<dynamic> likedBy = [];
                                                                        likedBy = await data['likedBy']??[];

                                                                        if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                                          likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                                                                        }
                                                                        else{
                                                                          likedBy.add(FirebaseAuth.instance.currentUser!.uid);}

                                                                        await    FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.buyRent).doc(data['docId']).update(
                                                                            {
                                                                              'likedBy':FieldValue.arrayUnion(likedBy)
                                                                            });
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
                                                                        List<dynamic> likedBy = [];
                                                                        likedBy = await data['likedBy']??[];

                                                                        if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                                          likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                                                                        }
                                                                        else{
                                                                          likedBy.add(FirebaseAuth.instance.currentUser!.uid);}

                                                                        await  FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.buyRent).doc(data['docId']).update(
                                                                            {
                                                                              'likedBy':FieldValue.arrayUnion(likedBy)
                                                                            });

                                                                        await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                                                                      }
                                                                      catch(e){
                                                                        print(e.toString());
                                                                      }
                                                                    },
                                                                    child: Icon(Icons.favorite,color: red,size: 18,)
                                                                );
                                                            }}),

                                                      // StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (
                                                      //     stream:
                                                      //     FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').where('docId',isEqualTo:data['docId']).snapshots(),
                                                      //
                                                      //     builder: (context, snapshot) {
                                                      //       if (snapshot.connectionState == ConnectionState.waiting) {
                                                      //         return  Center(
                                                      //           child: CircularProgressIndicator(color: primaryColor,),
                                                      //         );
                                                      //       } else if (snapshot.hasError) {
                                                      //         return Text('Error: ${snapshot.error}');
                                                      //       } else {
                                                      //         final docs1 = snapshot.data!.docs;
                                                      //         // Check if the property description contains any of the keywords
                                                      //         return
                                                      //           docs1.length==0?
                                                      //           InkWell(
                                                      //               onTap:()async{
                                                      //                 try{
                                                      //                   List<dynamic> likedBy = [];
                                                      //                   likedBy = await data['likedBy']??[];
                                                      //
                                                      //                   if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                      //                     likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                                                      //                   }
                                                      //                   else{
                                                      //                     likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                                                      //
                                                      //                   await  FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' :
                                                      //                   searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' :
                                                      //                   searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.buyRent).doc(data['docId']).update(
                                                      //                       {
                                                      //                         'likedBy':FieldValue.arrayUnion(likedBy)
                                                      //                       });
                                                      //
                                                      //                   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                                      //                       {
                                                      //                         'favouriteProperties':FieldValue.arrayUnion(likedBy)
                                                      //                       });
                                                      //
                                                      //                   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs [index]['docId']).set({
                                                      //                     'city':data['city'],
                                                      //                     'propertyType':data['propertyType'],
                                                      //                     'purpose':data['purpose'],
                                                      //                     'docId':data['docId'],
                                                      //                     'images':data['images'],
                                                      //                     'displayImage':data['displayImage'],
                                                      //                     'totalPrice':data['totalPrice'],
                                                      //                     'location':data['location'],
                                                      //
                                                      //                     'area':data['area'],
                                                      //                     'areaType':data['areaType'],
                                                      //                     'bathrooms':data['bathrooms'],
                                                      //                     'bedrooms':data['bedrooms'],
                                                      //                     'propertyDescription':data['propertyDescription'],
                                                      //                     'propertyTitle':data['propertyTitle'],
                                                      //                     'timestamp':data['timestamp'],
                                                      //                     'readyForPossession':data['readyForPossession'],
                                                      //                     'uid':data['uid'],
                                                      //                     'likedBy':data['likedBy'],
                                                      //                   });
                                                      //                 }
                                                      //                 catch(e){
                                                      //                   print(e.toString());
                                                      //                 }
                                                      //               },
                                                      //               child: Icon(Icons.favorite,color: lightTextColor,size: 18,)
                                                      //           ):
                                                      //           InkWell(
                                                      //               onTap:()async{
                                                      //                 try{
                                                      //                   List<dynamic> likedBy = [];
                                                      //                   likedBy = await data['likedBy']??[];
                                                      //
                                                      //                   if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                                                      //                     likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                                                      //                   }
                                                      //                   else{
                                                      //                     likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                                                      //
                                                      //                   await  FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' :
                                                      //                   searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' :
                                                      //                   searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.buyRent).doc(data['docId']).update(
                                                      //                       {
                                                      //                         'likedBy':FieldValue.arrayUnion(likedBy)
                                                      //                       });
                                                      //
                                                      //                   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                                                      //                 }
                                                      //                 catch(e){
                                                      //                   print(e.toString());
                                                      //                 }
                                                      //               },
                                                      //               child: Icon(Icons.favorite,color: red,size: 18,)
                                                      //           );
                                                      //       }}),
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
                          },itemCount: docs.length);

                    // ListView.builder(
                      //
                      //     itemBuilder: (context,index){
                      //       final data = docs[index].data();
                      //       return
                      //         InkWell(onTap: (){
                      //           try{
                      //             navigateWithTransition(
                      //                 context, SelectedProperty(
                      //               images: data['images']!=[]? data['images'] :[data['displayImage']],
                      //               totalPrice: data['totalPrice'],
                      //               posterUid: data['uid'],
                      //               beds: data['bedrooms'],
                      //               bathrooms: data['bathrooms'],
                      //               area: data['area'],
                      //               areaType: data['areaType'],
                      //               description: data['propertyDescription'],
                      //               title: data['propertyTitle'], timestamp: data['timestamp'], location: data['location'], docId: data['docId'], displayImage:  data['displayImage'],
                      //
                      //             ), TransitionType.slideRightToLeft);
                      //
                      //           }
                      //           catch(e){
                      //             print(e.toString());
                      //           }
                      //         },
                      //           child:
                      //           Container(
                      //             color:white,
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //
                      //               children: [
                      //                 Container(
                      //                   padding: EdgeInsets.symmetric(horizontal: 4),
                      //                   width: w,
                      //                   height: 150, decoration: BoxDecoration(
                      //                   color:white,
                      //                   borderRadius: BorderRadius.circular(5),
                      //                 ),
                      //                   alignment: Alignment.center,
                      //                   child: Row(
                      //                     crossAxisAlignment: CrossAxisAlignment.center,
                      //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       ClipRRect(
                      //                         borderRadius: BorderRadius.circular(5),
                      //                         child: Image.network(data['displayImage'],width: 140,height: 150,fit: BoxFit.fill,),
                      //                       ),
                      //                       SizedBox(width: 6.5,),
                      //                       Column(
                      //                         crossAxisAlignment: CrossAxisAlignment.start,
                      //                         children: [
                      //                           Row(
                      //                             mainAxisAlignment: MainAxisAlignment.start,
                      //                             children: [
                      //                               textRubik(getTimeDifference(data['timestamp']), greyShade3, w400, size10),
                      //                             ],
                      //                           ),
                      //                           SizedBox(height: 5,),
                      //                           Row(
                      //                             crossAxisAlignment: CrossAxisAlignment.center,
                      //                             mainAxisAlignment: MainAxisAlignment.start,
                      //                             children: [
                      //                               textRubik('PKR', darkTextColor, w500, size14),
                      //                               SizedBox(width: 3,),
                      //                               textRubik(data['totalPrice'], darkTextColor, w600, size18),
                      //                             ],
                      //                           ),
                      //                           SizedBox(height: 5,),
                      //                           Row(
                      //                             crossAxisAlignment: CrossAxisAlignment.center,
                      //                             children: [
                      //                               textRubik(data['location']+ ', '+data['city'], darkTextColor, w500, size15),
                      //                             ],
                      //                           ),
                      //                           SizedBox(height: 5,),
                      //                           Row(
                      //                             crossAxisAlignment: CrossAxisAlignment.center,
                      //                             mainAxisAlignment: MainAxisAlignment.start,
                      //                             children: [
                      //                               textRubik(data['propertyTitle'], greyShade3, w400, size12),
                      //                             ],
                      //                           ),
                      //                           SizedBox(height: 5,),
                      //                           Container( width: w-140 - 8-8,
                      //                             child: Row(
                      //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                               crossAxisAlignment: CrossAxisAlignment.center,
                      //                               children: [
                      //                                 Row(
                      //                                   crossAxisAlignment: CrossAxisAlignment.center,
                      //                                   mainAxisSize: MainAxisSize.min ,
                      //                                   children: [
                      //                                     data['bedrooms']!='null'?  Row(
                      //                                       crossAxisAlignment: CrossAxisAlignment.center,
                      //                                       children: [
                      //                                         Icon(Icons.bed,size: 15,color: darkTextColor,),
                      //                                         SizedBox(width: 3,),
                      //                                         textRubik(data['bedrooms'], darkTextColor, w500, size12),
                      //                                       ],
                      //                                     ):Container(),
                      //                                     SizedBox(width: 5,),
                      //                                     data['bedrooms']!='null'?Row(
                      //                                       crossAxisAlignment: CrossAxisAlignment.center,
                      //                                       children: [
                      //                                         Icon(Icons.bathroom_outlined,size: 15,color: darkTextColor,),
                      //                                         SizedBox(width: 3,),
                      //                                         textRubik(data['bathrooms'], darkTextColor, w500, size12),
                      //                                       ],
                      //                                     ):Container(),
                      //                                     SizedBox(width: 5,),
                      //                                     Row(
                      //                                       crossAxisAlignment: CrossAxisAlignment.center,
                      //                                       children: [
                      //                                         Icon(Icons.photo_size_select_small_sharp,size: 15,color: darkTextColor,),
                      //                                         SizedBox(width: 3,),
                      //                                         textRubik(
                      //                                             formatArea(convertArea(data['areaType'], data['area'], 'Marla')) + ' ' + 'Marla',
                      //                                             darkTextColor,
                      //                                             w500,
                      //                                             size12
                      //                                         ),
                      //
                      //
                      //                                       ],
                      //                                     ),
                      //                                     SizedBox(width: 5,),
                      //                                   ],
                      //                                 ),
                      //                                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      //                                     stream:
                      //                                     FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').where('docId',isEqualTo:data['docId']).snapshots(),
                      //
                      //                                     builder: (context, snapshot) {
                      //                                       if (snapshot.connectionState == ConnectionState.waiting) {
                      //                                         return  Center(
                      //                                           child: CircularProgressIndicator(color: primaryColor,),
                      //                                         );
                      //                                       } else if (snapshot.hasError) {
                      //                                         return Text('Error: ${snapshot.error}');
                      //                                       } else {
                      //                                         final docs1 = snapshot.data!.docs;
                      //                                         // Check if the property description contains any of the keywords
                      //                                         return
                      //                                           docs1.length==0?
                      //                                           InkWell(
                      //                                               onTap:()async{
                      //                                                 try{
                      //                                                   List<dynamic> likedBy = [];
                      //                                                   likedBy = await data['likedBy']??[];
                      //
                      //                                                   if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                      //                                                     likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                      //                                                   }
                      //                                                   else{
                      //                                                     likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                      //
                      //                                                   await  FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.buyRent).doc(data['docId']).update(
                      //                                                       {
                      //                                                         'likedBy':FieldValue.arrayUnion(likedBy)
                      //                                                       });
                      //                                                   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs [index]['docId']).set({
                      //                                                     'city':data['city'],
                      //                                                     'propertyType':data['propertyType'],
                      //                                                     'purpose':data['purpose'],
                      //                                                     'docId':data['docId'],
                      //                                                     'images':data['images'],
                      //                                                     'displayImage':data['displayImage'],
                      //                                                     'totalPrice':data['totalPrice'],
                      //                                                     'location':data['location'],
                      //
                      //                                                     'area':data['area'],
                      //                                                     'areaType':data['areaType'],
                      //                                                     'bathrooms':data['bathrooms'],
                      //                                                     'bedrooms':data['bedrooms'],
                      //                                                     'propertyDescription':data['propertyDescription'],
                      //                                                     'propertyTitle':data['propertyTitle'],
                      //                                                     'timestamp':data['timestamp'],
                      //                                                     'readyForPossession':data['readyForPossession'],
                      //                                                     'uid':data['uid'],
                      //                                                     'likedBy':data['likedBy'],
                      //                                                   });
                      //                                                 }
                      //                                                 catch(e){
                      //                                                   print(e.toString());
                      //                                                 }
                      //                                               },
                      //                                               child: Icon(Icons.favorite,color: lightTextColor,size: 18,)
                      //                                           ):
                      //                                           InkWell(
                      //                                               onTap:()async{
                      //                                                 try{
                      //                                                   List<dynamic> likedBy = [];
                      //                                                   likedBy = await data['likedBy']??[];
                      //
                      //                                                   if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                      //                                                     likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                      //                                                   }
                      //                                                   else{
                      //                                                     likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                      //
                      //                                                   await  FirebaseFirestore.instance.collection(searchProvider.location).doc(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyType == 'Houses' ? 'Homes' : searchProvider.propertyType == 'Plots' ? 'Plots' : 'Commercial').doc(searchProvider.buyRent).collection(searchProvider.propertyType).doc(data['docId']).update(
                      //                                                       {
                      //                                                         'likedBy':FieldValue.arrayUnion(likedBy)
                      //                                                       });
                      //
                      //                                                   await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                      //                                                 }
                      //                                                 catch(e){
                      //                                                   print(e.toString());
                      //                                                 }
                      //                                               },
                      //                                               child: Icon(Icons.favorite,color: red,size: 18,)
                      //                                           );
                      //                                       }}),
                      //                               ],
                      //                             ),
                      //                           ),
                      //                           SizedBox(height: 8,),
                      //
                      //                           Container(
                      //                             width: w-140 - 35,
                      //                             child: Row(
                      //                               crossAxisAlignment: CrossAxisAlignment.center,
                      //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //                               children: [
                      //                                 InkWell(
                      //                                   onTap:()async{
                      //                                     try{
                      //
                      //                                       try{
                      //                                         String phoneNumber = await data['phone'];
                      //
                      //                                         if (phoneNumber.isNotEmpty) {
                      //                                           String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp URL with phone number
                      //                                           if (await canLaunch(whatsappUrl)) {
                      //                                             await launch(whatsappUrl);
                      //                                           } else {
                      //                                             throw 'Could not launch $whatsappUrl';
                      //                                           }
                      //                                         }
                      //                                         else{
                      //                                           throw 'Phone number is empty';
                      //                                         }
                      //                                       }
                      //                                       catch(e){
                      //                                         print(e.toString());
                      //                                       }
                      //                                     }
                      //                                     catch(e){
                      //                                       print(e.toString());
                      //                                     }
                      //                                   },
                      //                                   child: Container(
                      //                                     width: 38,
                      //                                     height: 35,
                      //                                     alignment: Alignment.center,
                      //                                     decoration: BoxDecoration(
                      //                                         color:primaryColor,
                      //                                         border: Border.all(color: primaryColor,width: 1),
                      //                                         borderRadius: BorderRadius.circular(8)
                      //                                     ),
                      //                                     child: Center(
                      //                                       child: Image.asset('assets/whatsapp.png',width: 16,height: 16,fit: BoxFit.cover,color: white,),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                                 InkWell(
                      //                                   onTap:()async{
                      //                                     try{
                      //                                       String phoneNumber = await data['phone'];
                      //
                      //                                       try{
                      //
                      //                                         if (phoneNumber.isNotEmpty) {
                      //                                           String phoneCallUrl = "tel:$phoneNumber"; // Phone call URL with phone number
                      //                                           if (await canLaunch(phoneCallUrl)) {
                      //                                             await launch(phoneCallUrl);
                      //                                           } else {
                      //                                             throw 'Could not launch $phoneCallUrl';
                      //                                           }
                      //                                         } else {
                      //                                           throw 'Phone number is empty';
                      //                                         }
                      //                                       }
                      //                                       catch(e){
                      //                                         print(e.toString());
                      //                                       }
                      //                                     }
                      //                                     catch(e){
                      //                                       print(e.toString());
                      //                                     }
                      //                                   },
                      //                                   child: Container(
                      //                                     width: 38,
                      //                                     height: 35,
                      //                                     alignment: Alignment.center,
                      //                                     decoration: BoxDecoration(
                      //                                         border: Border.all(color: primaryColor,width: 1),
                      //                                         color:primaryColor,
                      //                                         borderRadius: BorderRadius.circular(8)
                      //
                      //                                     ),
                      //                                     child: Center(
                      //                                       child: Icon(Icons.call,color: white,),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                                 InkWell(
                      //                                   onTap:()async{
                      //                                     try {
                      //
                      //                                       String phoneNumber = await data['phone'];
                      //
                      //                                       if (phoneNumber.isNotEmpty) {
                      //                                         String smsUrl = "sms:$phoneNumber"; // SMS URL with phone number
                      //                                         if (await canLaunch(smsUrl)) {
                      //                                           await launch(smsUrl);
                      //                                         } else {
                      //                                           throw 'Could not launch $smsUrl';
                      //                                         }
                      //                                       } else {
                      //                                         throw 'Phone number is empty';
                      //                                       }
                      //                                     } catch(e) {
                      //                                       print(e.toString());
                      //                                     }
                      //                                   },
                      //                                   child: Container(
                      //                                     width: 38,
                      //                                     height: 35,
                      //                                     alignment: Alignment.center,
                      //                                     decoration: BoxDecoration(
                      //                                         border: Border.all(color: primaryColor,width: 1),
                      //                                         borderRadius: BorderRadius.circular(8)
                      //
                      //                                     ),
                      //                                     child: Center(
                      //                                       child:textRubik('SMS', primaryColor, w500, size14),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //
                      //                                 InkWell(  onTap:(){
                      //                                   navigateWithTransition(context, ChatScreen(user2Uid: data['uid'],), TransitionType.slideRightToLeft);
                      //                                 },
                      //                                   child: Container(
                      //                                     width: 38,
                      //                                     height: 35,
                      //                                     alignment: Alignment.center,
                      //                                     decoration: BoxDecoration(
                      //                                         border: Border.all(color: primaryColor,width: 1),
                      //                                         borderRadius: BorderRadius.circular(8)
                      //
                      //                                     ),
                      //                                     child: Center(
                      //
                      //                                         child:Icon(CupertinoIcons.chat_bubble_2,color: primaryColor,)
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             ),
                      //                           )
                      //                         ],
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 SizedBox(height: 5,),
                      //                 Divider(color: lightTextColor.withOpacity(0.3),thickness: 1,)
                      //               ],
                      //             ),
                      //           ),
                      //         );
                      //     },itemCount: docs.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);

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
