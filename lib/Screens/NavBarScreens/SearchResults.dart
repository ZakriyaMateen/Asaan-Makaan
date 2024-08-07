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

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {


  List<Map<String,dynamic>> searchOptions = [
    {'iconData':Icons.filter_alt_sharp,'title':'Filters'},
    {'iconData':Icons.sort,'title':'Sort'},
    {'iconData':Icons.location_searching,'title':'Location'},
    {'iconData':Icons.price_check_rounded,'title':'Price Range'},

  ];
  List<Map<String,dynamic>> sort = [
    // {'iconData':Icons.star_border,'title':'Popular','isSelected':false},
    // {'iconData':Icons.access_time_rounded,'title':'Newest','isSelected':true},
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
            SizedBox(height: h*0.06,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w*0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap:(){Navigator.pop(context);},
                          child: Icon(Icons.arrow_back_ios,color: darkTextColor,size: 17,)),
                      SizedBox(width: 6,),
                      textRubik('Search Results', darkTextColor, w500, size18)
                    ],
                  ),
                  InkWell(
                    onTap:()async{
                      try{
                        showDialog(context: context, builder: (context){
                          return Dialog(
                            backgroundColor: white,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child:
                              Container(
                                width: w*0.8,
                                height:250,
                                decoration:BoxDecoration(
                                  color:white,
                                  borderRadius:BorderRadius.circular(12)
                                ) ,
                                child:
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: w*0.04),
                                    child: Column(
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        textRoboto('Search Title', darkTextColor, w500, size18),
                                        SizedBox(height:10),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                                child: TextFormField(
                                                  controller: searchTitleController,
                                                  onFieldSubmitted: (v)async{
                                                    try{
                                                      final searchProvider = Provider.of<SearchProvider>(context,listen:false);

                                                      String buyRent = 'Buy';
                                                      if(searchProvider.buyRent[0]==true){
                                                        buyRent = 'RentOut';
                                                      }
                                                      else{
                                                        buyRent = 'Sell';
                                                      }
                                                      print(buyRent);
                                                      DocumentReference savedSearchRef = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('SavedSearches').add({
                                                        'city':searchProvider.selectedCity,
                                                        'buyRent':buyRent,
                                                        'searchTitle':searchTitleController.text.toString(),
                                                        'minPrice':price1Controller.text.toString(),
                                                        'maxPrice':price2Controller.text.toString(),
                                                        'minRange':range1Controller.text.toString(),
                                                        'maxRange':range2Controller.text.toString(),
                                                        'areaType':searchProvider.areaType,
                                                      });
                                                      savedSearchRef.update({
                                                        'docId':savedSearchRef.id
                                                      }).then((value) {
                                                        Navigator.pop(context);
                                                      });
                                                    }
                                                    catch(e){
                                                      print(e.toString());
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(color: lightTextColor,width: 1)
                                                      ),
                                                      enabledBorder:  OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(color: lightTextColor,width: 1)
                                                      ),
                                                      focusedBorder:  OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(color: darkTextColor,width: 1.75)
                                                      ),
                                                      errorBorder:  OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(10),
                                                          borderSide: BorderSide(color: red,width: 1.75)
                                                      )
                                                  ),
                                                  style:GoogleFonts.roboto(
                                                    textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                                  ),
                                                )),
                                                SizedBox(
                                                  height: 10,
                                                ),

                                          ],
                                        ),
                                        SizedBox(height: 12,),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: ()async{
                                                try{
                                                  final searchProvider = Provider.of<SearchProvider>(context,listen:false);

                                                  String buyRent = 'Buy';
                                                  if(searchProvider.buyRent[0]==true){
                                                    buyRent = 'RentOut';
                                                  }
                                                  else{
                                                    buyRent = 'Sell';
                                                  }
                                                  print(buyRent);
                                                  DocumentReference savedSearchRef = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('SavedSearches').add({
                                                    'city':searchProvider.selectedCity,
                                                    'buyRent':buyRent,
                                                    'searchTitle':searchTitleController.text.toString(),
                                                    'minPrice':price1Controller.text.toString(),
                                                    'maxPrice':price2Controller.text.toString(),
                                                    'minRange':range1Controller.text.toString(),
                                                    'maxRange':range2Controller.text.toString(),
                                                    'homePlotCommercial':searchProvider.propertyTypeSelected

                                                  });
                                                  savedSearchRef.update({
                                                    'docId':savedSearchRef.id
                                                  }).then((value) {
                                                    Navigator.pop(context);
                                                  });
                                                }
                                                catch(e){
                                                  print(e.toString());
                                                }
                                              },
                                              child: Container(
                                                  width: 100,
                                                  height:45,
                                                  decoration:BoxDecoration(
                                                      borderRadius: BorderRadius.circular(100),
                                                      color:primaryColor
                                                  ),
                                                  child:Center(
                                                      child:textRoboto('Save', white, w500, size16)
                                                  )
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )

                              )
                          );

                        });

                      }
                      catch(e){
                        print(e.toString());
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bookmark_border,color: darkTextColor,size: 17,),
                        SizedBox(width: 3.5,),
                        textRubik('Save', darkTextColor, w400, size16)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12,),
            Container(
              width: w,
              height: 42,
              child: ListView.builder(itemBuilder: (context,index){
                return InkWell(
                  onTap:
                  index == 0 ? (){
                    print('index 0');

                    navigateWithTransition(context, Search(), TransitionType.slideRightToLeft);}:

                  index == 2 ? (){navigateWithTransition(context, SelectLocationSearch(), TransitionType.slideRightToLeft);}:


                    index == 3 ?(){

                      showModalBottomSheet(context: context, builder: (context){
                        return StatefulBuilder(builder: (BuildContext context, StateSetter setstate){
                          return  Container(
                            width: w,
                            height: h*0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 15,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w*0.05),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(searchOptions[index]['iconData'],size: 18,color: lightTextColor,),
                                          SizedBox(width: 5,),
                                          textRubik(searchOptions[index]['title'], darkTextColor, w500, size18)
                                        ],
                                      ),
                                      InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.close,size: 20,color: darkTextColor,),)
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Divider(thickness: 1,color: greyShade3.withOpacity(0.2),),
                                SizedBox(height: 20,),

                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal:7),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: TextFormField(
                                            controller: price1Controller,
                                            onChanged: (v){
                                              setState(() {
                                                price1 = v;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: lightTextColor,width: 1)
                                                ),
                                                enabledBorder:  OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: lightTextColor,width: 1)
                                                ),
                                                focusedBorder:  OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: darkTextColor,width: 1.75)
                                                ),
                                                errorBorder:  OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: red,width: 1.75)
                                                )
                                            ),
                                            style:GoogleFonts.roboto(
                                              textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                            ),
                                          )),
                                      SizedBox(width: 5,),
                                      textRubik('TO', darkTextColor, w500, size16),
                                      SizedBox(width: 5,),
                                      Flexible(child: TextFormField(
                                        controller: price2Controller,
                                        onChanged: (v){
                                          setState(() {
                                            price2 = v;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: lightTextColor,width: 1)
                                            ),
                                            enabledBorder:  OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: lightTextColor,width: 1)
                                            ),
                                            focusedBorder:  OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: darkTextColor,width: 1.75)
                                            ),
                                            errorBorder:  OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: red,width: 1.75)
                                            )
                                        ),
                                        style:GoogleFonts.roboto(
                                          textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                        ),
                                      ))
                                    ],
                                  ),
                                )


                              ],
                            ),
                          );
                        }
                        );
                      },
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12),)),backgroundColor: white);
                    }:


                    (){
                    showModalBottomSheet(context: context, builder: (context){
                      return StatefulBuilder(builder: (BuildContext context, StateSetter setstate){
                        return  Container(
                          width: w,
                          height: h*0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 15,),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: w*0.05),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(searchOptions[index]['iconData'],size: 18,color: lightTextColor,),
                                        SizedBox(width: 5,),
                                        textRubik(searchOptions[index]['title'], darkTextColor, w500, size18)
                                      ],
                                    ),
                                    InkWell(onTap: (){Navigator.pop(context);},child: Icon(Icons.close,size: 20,color: darkTextColor,),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Divider(thickness: 1,color: greyShade3.withOpacity(0.2),),
                              SizedBox(height: 10,),
                              ListView.builder(itemBuilder: (context,index){
                                return InkWell(
                                  onTap: (){
                                    for(int i = 0 ; i<sort.length ; i++){
                                      sort[i]['isSelected'] = false;
                                    }
                                    setstate(() {
                                      sort[index]['isSelected'] = true;
                                    });
                                    setState(() {
                                      sort[index]['isSelected'] = true;

                                    });
                                  },
                                  child: Container(
                                    width: w,
                                    height: 45,
                                    margin: EdgeInsets.symmetric(horizontal: w*0.06,vertical: 3),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(sort[index]['iconData'],size: 19,color: darkTextColor,),
                                            SizedBox(width: 5,),
                                            textRubik(sort[index]['title'], darkTextColor, w400, size17),
                                          ],
                                        ),
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: darkTextColor,width: 1.5)
                                          ),
                                          padding: EdgeInsets.all(2),
                                          child:
                                          sort[index]['isSelected']?  Center(
                                            child: Container(
                                              width: 22,
                                              height: 22,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: primaryColor,width: 1.5)
                                              ),
                                            ),
                                          ):Container(),
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },itemCount: sort.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),)

                            ],
                          ),
                        );
                      });
                    },shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12),)),backgroundColor: white);}     ,
                    child: Container(
                    height: 40,
                    margin: EdgeInsets.only(left: index==0?3:0,right: 7),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: greyShade3,width: 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(searchOptions[index]['iconData'],size: 15,color: primaryColor,),
                        SizedBox(width: 3,),
                        textRubik(searchOptions[index]['title'], lightTextColor, w400, size15)
                      ],
                    ),
                  ),
                );
              },scrollDirection: Axis.horizontal,itemCount: searchOptions.length,),
            ),
            Divider(thickness: 1,color: greyShade3.withOpacity(0.2),),
            Container(
              height: h*0.87,
              width: w,
              child:
              Consumer<SearchProvider>(builder: (context,searchProvider,_){
                String buyRent = 'Buy';
                      if(searchProvider.buyRent[0]==true){
                        buyRent = 'RentOut';
                      }
                      else{
                        buyRent = 'Sell';
                      }
                  print(buyRent);
                // CollectionReference rootRef = await FirebaseFirestore
                //     .instance.collection(
                //     provider.selectedCity
                // );
                //
                // CollectionReference typeRef = await rootRef
                //     .doc(provider.propertyTypeOption).collection(
                //     provider.propertyTypeOption
                // );
                //
                // CollectionReference cityRef = await typeRef
                //     .doc(provider.purposeOptionSelected).collection(
                //     provider.purposeOptionSelected
                // );
                  return
                    price1!=''?
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                            .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                            .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                            .doc(buyRent)
                            .collection(buyRent)
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
                            final rootDocs = snapshot.data!.docs;
                            var docs = rootDocs.where((doc) {
                              var data = doc.data() as Map<String, dynamic>;

                              // Check if the property description contains any of the keywords
                              bool containsKeyword = true;
                              if(searchProvider.keywordList.isNotEmpty){
                                containsKeyword = searchProvider.keywordList.any((keyword) {
                                  return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                                });
                              }
                              bool containsImages = false;
                              if(data['images']!=[]){
                                containsImages = true;
                              }

                              double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                              if( searchProvider.propertyTypeSelected == 'Houses'){
                                if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                                  return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                      (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                      (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                      (containsKeyword && containsImages) &&
                                      (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                      ((price1.isEmpty|| double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                          (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                      ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                          (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)))
                                  ;

                                } else {
                                  return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                      (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                      (containsKeyword) &&
                                      (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&

                                      (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                      ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                          (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                      ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                          (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                }
                              }
                              else   if (searchProvider.propertyTypeSelected == 'Plots'){

                                if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                  return
                                    (containsKeyword && containsImages) &&
                                        (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                        ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                        ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                            (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                } else {
                                  return
                                    (containsKeyword) &&
                                        (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                        ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                        ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                            (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                }
                              }
                              else{
                                if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                  return
                                    (containsKeyword && containsImages) &&
                                        (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                        ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                        ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                            (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                } else {

                                  return
                                    (containsKeyword) &&
                                        (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                        ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                        ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                            (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                }
                              }

                            }).toList();

                            return
                              ListView.builder(

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
                                                                          formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
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

                                                                                await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                                await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                          }}):

                        range1!=''?
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                                .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                            searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                            searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                .doc(buyRent)
                                .collection(buyRent)
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
                                final rootDocs = snapshot.data!.docs;
                                var docs = rootDocs.where((doc) {
                                  var data = doc.data() as Map<String, dynamic>;

                                  // Check if the property description contains any of the keywords
                                  bool containsKeyword = true;
                                  if(searchProvider.keywordList.isNotEmpty){
                                    containsKeyword = searchProvider.keywordList.any((keyword) {
                                      return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                                    });
                                  }
                                  bool containsImages = false;
                                  if(data['images']!=[]){
                                    containsImages = true;
                                  }

                                  double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                                  if( searchProvider.propertyTypeSelected == 'Houses'){
                                    if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                                      return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                          (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                          (containsKeyword && containsImages) &&
                                          (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                          ((price1.isEmpty|| double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                              (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                          ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                              (range2.isEmpty || areaDocument <= double.parse(range2)));

                                    } else {
                                      return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                          (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                          (containsKeyword) &&
                                          (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                          (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                          ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                              (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                          ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                              (range2.isEmpty || areaDocument <= double.parse(range2)));
                                    }
                                  }
                                  else   if (searchProvider.propertyTypeSelected == 'Plots'){

                                    if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                      return
                                        (containsKeyword && containsImages) &&
                                            (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                            ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                            ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                                (range2.isEmpty || areaDocument <= double.parse(range2)));

                                    } else {
                                      return
                                        (containsKeyword) &&
                                            (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                                (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                            ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                                (range2.isEmpty || areaDocument <= double.parse(range2)));
                                    }
                                  }
                                  else{
                                    if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                      return
                                        (containsKeyword && containsImages) &&
                                            (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                            ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                (price2.isEmpty || double.parse(data['totalPrice']) <= double.parse(price2)))&&
                                            ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                                (range2.isEmpty || areaDocument <= double.parse(range2)));

                                    } else {

                                      return
                                        (containsKeyword) &&
                                            (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                            ((price1.isEmpty || double.parse(data['totalPrice']) >= double.parse(price1)) &&
                                                (price2.isEmpty || double.parse( data['totalPrice']) <= double.parse(price2)))&&
                                            ((range1.isEmpty || areaDocument >= double.parse(range1)) &&
                                                (range2.isEmpty || areaDocument <= double.parse(range2)));
                                    }
                                  }

                                }).toList();

                                return
                                  ListView.builder(

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
                                                                              formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
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

                                                                                    await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                                    await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                              }}):



                        // sort[0]['isSelected']==true?
                        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //     stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                        //         .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        //     searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                        //         .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        //     searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                        //         .doc(buyRent)
                        //         .collection(buyRent) // Sort by 'createdAt' field in descending order
                        //         .snapshots(),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                        //         return const Center(
                        //           child: CircularProgressIndicator(),
                        //         );
                        //       } else if (snapshot.hasError) {
                        //         return Text('Error: ${snapshot.error}');
                        //       } else {
                        //         final rootDocs = snapshot.data!.docs;
                        //         var docs = rootDocs.where((doc) {
                        //           var data = doc.data() as Map<String, dynamic>;
                        //
                        //           // Check if the property description contains any of the keywords
                        //           bool containsKeyword = true;
                        //           if(searchProvider.keywordList.isNotEmpty){
                        //             containsKeyword = searchProvider.keywordList.any((keyword) {
                        //               return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                        //             });
                        //           }
                        //           bool containsImages = false;
                        //           if(data['images']!=[]){
                        //             containsImages = true;
                        //           }
                        //
                        //           double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                        //           if( searchProvider.propertyTypeSelected == 'Houses'){
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                        //               return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                        //                   (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                        //                   (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                   (containsKeyword && containsImages) &&
                        //                   (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                        //                   ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                       (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                   ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                       (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                        //                   (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                        //                   (containsKeyword) &&
                        //                   (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                   (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                        //                   ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                       (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                   ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                       (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //           else   if (searchProvider.propertyTypeSelected == 'Plots'){
                        //
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                        //               return
                        //                 (containsKeyword && containsImages) &&
                        //                     (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return
                        //                 (containsKeyword) &&
                        //                     (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                        //                     (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //           else{
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                        //               return
                        //                 (containsKeyword && containsImages) &&
                        //                     (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return
                        //                 (containsKeyword) &&
                        //                     (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                     (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //
                        //         }).toList();
                        //         docs.sort((a, b) {
                        //           var aData = a.data() as Map<String, dynamic>;
                        //           var bData = b.data() as Map<String, dynamic>;
                        //
                        //           num count1 = aData['likedBy']!= null? (aData['likedBy'] as List).length:0;
                        //           num count2 = bData['likedBy']!= null? (bData['likedBy'] as List).length:0;
                        //
                        //           return count2.compareTo(count1);
                        //         });
                        //
                        //         return
                        //           ListView.builder(
                        //               itemBuilder: (context,index){
                        //                 final data = docs[index].data();
                        //                 return
                        //                   InkWell(onTap: (){
                        //                     try{
                        //                       navigateWithTransition(
                        //                           context, SelectedProperty(
                        //                         images: data['images']!=[]? data['images'] :[data['displayImage']],
                        //                         totalPrice: data['totalPrice'],
                        //                         posterUid: data['uid'],
                        //                         beds: data['bedrooms'],
                        //                         bathrooms: data['bathrooms'],
                        //                         area: data['area'],
                        //                         areaType: data['areaType'],
                        //                         description: data['propertyDescription'],
                        //                         title: data['propertyTitle'], timestamp: data['timestamp'], location: data['location'], docId: data['docId'], displayImage:  data['displayImage'],
                        //                       ), TransitionType.slideRightToLeft);
                        //                     }
                        //                     catch(e){
                        //                       print(e.toString());
                        //                     }
                        //                   },
                        //                     child:
                        //                     Container(
                        //                       color:white,
                        //                       child: Column(
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: [
                        //                           Container(
                        //                             padding: EdgeInsets.symmetric(horizontal: 4),
                        //                             width: w,
                        //                             height: 150, decoration: BoxDecoration(
                        //                             color:white,
                        //                             borderRadius: BorderRadius.circular(5),
                        //                           ),
                        //                             alignment: Alignment.center,
                        //                             child: Row(
                        //                               crossAxisAlignment: CrossAxisAlignment.center,
                        //                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                               children: [
                        //                                 ClipRRect(
                        //                                   borderRadius: BorderRadius.circular(5),
                        //                                   child: Image.network(data['displayImage'],width: 140,height: 150,fit: BoxFit.fill,),
                        //                                 ),
                        //                                 SizedBox(width: 6.5,),
                        //                                 Column(
                        //                                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                                   children: [
                        //                                     Row(
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik(getTimeDifference(data['timestamp']), greyShade3, w400, size10),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik('PKR', darkTextColor, w500, size14),
                        //                                         SizedBox(width: 3,),
                        //                                         textRubik(data['totalPrice'], darkTextColor, w600, size18),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       children: [
                        //                                         textRubik((data['location']+ ', '+data['city']).toString().length<=25?(data['location']+ ', '+data['city']):(data['location']+ ', '+data['city']).toString().substring(0,24)+'...', darkTextColor, w500, size15),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik(data['propertyTitle'], greyShade3, w400, size12),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Container( width: w-140 - 8-8,
                        //                                       child: Row(
                        //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                         crossAxisAlignment: CrossAxisAlignment.center,
                        //                                         children: [
                        //                                           Row(
                        //                                             crossAxisAlignment: CrossAxisAlignment.center,
                        //                                             mainAxisSize: MainAxisSize.min ,
                        //                                             children: [
                        //                                               data['bedrooms']!='null'?  Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.bed,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(data['bedrooms'], darkTextColor, w500, size12),
                        //                                                 ],
                        //                                               ):Container(),
                        //                                               SizedBox(width: 5,),
                        //                                               data['bedrooms']!='null'?Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.bathroom_outlined,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(data['bathrooms'], darkTextColor, w500, size12),
                        //                                                 ],
                        //                                               ):Container(),
                        //                                               SizedBox(width: 5,),
                        //                                               Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.photo_size_select_small_sharp,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(
                        //                                                       formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
                        //                                                       darkTextColor,
                        //                                                       w500,
                        //                                                       size12
                        //                                                   ),
                        //                                                 ],
                        //                                               ),
                        //                                               SizedBox(width: 5,),
                        //                                             ],
                        //                                           ),
                        //
                        //
                        //                                           StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //                                               stream:
                        //                                               FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').where('docId',isEqualTo:data['docId']).snapshots(),
                        //
                        //                                               builder: (context, snapshot) {
                        //                                                 if (snapshot.connectionState == ConnectionState.waiting) {
                        //                                                   return  Center(
                        //                                                     child: CircularProgressIndicator(color: primaryColor,),
                        //                                                   );
                        //                                                 } else if (snapshot.hasError) {
                        //                                                   return Text('Error: ${snapshot.error}');
                        //                                                 } else {
                        //                                                   final docs1 = snapshot.data!.docs;
                        //                                                   // Check if the property description contains any of the keywords
                        //                                                   return
                        //                                                     docs1.length==0?
                        //                                                     InkWell(
                        //                                                         onTap:()async{
                        //                                                           try{
                        //                                                             List<dynamic> likedBy = [];
                        //                                                             likedBy = await data['likedBy']??[];
                        //
                        //                                                             if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                        //                                                               likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                        //                                                             }
                        //                                                             else{
                        //                                                               likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                        //
                        //                                                             await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
                        //                                                                 {
                        //                                                                   'likedBy':FieldValue.arrayUnion(likedBy)
                        //                                                                 });
                        //                                                             await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs [index]['docId']).set({
                        //                                                               'city':data['city'],
                        //                                                               'propertyType':data['propertyType'],
                        //                                                               'purpose':data['purpose'],
                        //                                                               'docId':data['docId'],
                        //                                                               'images':data['images'],
                        //                                                               'displayImage':data['displayImage'],
                        //                                                               'totalPrice':data['totalPrice'],
                        //                                                               'location':data['location'],
                        //
                        //                                                               'area':data['area'],
                        //                                                               'areaType':data['areaType'],
                        //                                                               'bathrooms':data['bathrooms'],
                        //                                                               'bedrooms':data['bedrooms'],
                        //                                                               'propertyDescription':data['propertyDescription'],
                        //                                                               'propertyTitle':data['propertyTitle'],
                        //                                                               'timestamp':data['timestamp'],
                        //                                                               'readyForPossession':data['readyForPossession'],
                        //                                                               'uid':data['uid'],
                        //                                                               'likedBy':data['likedBy'],
                        //                                                             });
                        //                                                           }
                        //                                                           catch(e){
                        //                                                             print(e.toString());
                        //                                                           }
                        //                                                         },
                        //                                                         child: Icon(Icons.favorite,color: lightTextColor,size: 18,)
                        //                                                     ):
                        //                                                     InkWell(
                        //                                                         onTap:()async{
                        //                                                           try{
                        //                                                             List<dynamic> likedBy = [];
                        //                                                             likedBy = await data['likedBy']??[];
                        //
                        //                                                             if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                        //                                                               likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                        //                                                             }
                        //                                                             else{
                        //                                                               likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                        //
                        //                                                             await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
                        //                                                                 {
                        //                                                                   'likedBy':FieldValue.arrayUnion(likedBy)
                        //                                                                 });
                        //
                        //                                                             await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                        //                                                           }
                        //                                                           catch(e){
                        //                                                             print(e.toString());
                        //                                                           }
                        //                                                         },
                        //                                                         child: Icon(Icons.favorite,color: red,size: 18,)
                        //                                                     );
                        //                                                 }}),
                        //
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                     SizedBox(height: 8,),
                        //                                     Container(
                        //                                       width: w-140 - 35,
                        //                                       child: Row(
                        //                                         crossAxisAlignment: CrossAxisAlignment.center,
                        //                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //                                         children: [
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try{
                        //                                                 try{
                        //                                                   String phoneNumber = await data['phone'];
                        //                                                   if (phoneNumber.isNotEmpty) {
                        //                                                     String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp URL with phone number
                        //                                                     if (await canLaunch(whatsappUrl)) {
                        //                                                       await launch(whatsappUrl);
                        //                                                     } else {
                        //                                                       throw 'Could not launch $whatsappUrl';
                        //                                                     }
                        //                                                   }
                        //                                                   else{
                        //                                                     throw 'Phone number is empty';
                        //                                                   }
                        //                                                 }
                        //                                                 catch(e){
                        //                                                   print(e.toString());
                        //                                                 }
                        //                                               }
                        //                                               catch(e){
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   color:primaryColor,
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child: Image.asset('assets/whatsapp.png',width: 16,height: 16,fit: BoxFit.cover,color: white,),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try{
                        //                                                 String phoneNumber = await data['phone'];
                        //
                        //                                                 try{
                        //
                        //                                                   if (phoneNumber.isNotEmpty) {
                        //                                                     String phoneCallUrl = "tel:$phoneNumber"; // Phone call URL with phone number
                        //                                                     if (await canLaunch(phoneCallUrl)) {
                        //                                                       await launch(phoneCallUrl);
                        //                                                     } else {
                        //                                                       throw 'Could not launch $phoneCallUrl';
                        //                                                     }
                        //                                                   } else {
                        //                                                     throw 'Phone number is empty';
                        //                                                   }
                        //                                                 }
                        //                                                 catch(e){
                        //                                                   print(e.toString());
                        //                                                 }
                        //                                               }
                        //                                               catch(e){
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   color:primaryColor,
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child: Icon(Icons.call,color: white,),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try {
                        //
                        //                                                 String phoneNumber = await data['phone'];
                        //
                        //                                                 if (phoneNumber.isNotEmpty) {
                        //                                                   String smsUrl = "sms:$phoneNumber"; // SMS URL with phone number
                        //                                                   if (await canLaunch(smsUrl)) {
                        //                                                     await launch(smsUrl);
                        //                                                   } else {
                        //                                                     throw 'Could not launch $smsUrl';
                        //                                                   }
                        //                                                 } else {
                        //                                                   throw 'Phone number is empty';
                        //                                                 }
                        //                                               } catch(e) {
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child:textRubik('SMS', primaryColor, w500, size14),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //
                        //                                           InkWell(  onTap:(){
                        //                                             navigateWithTransition(context, ChatScreen(user2Uid: data['uid'],), TransitionType.slideRightToLeft);
                        //                                           },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //
                        //                                                   child:Icon(CupertinoIcons.chat_bubble_2,color: primaryColor,)
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                         ],
                        //                                       ),
                        //                                     )
                        //                                   ],
                        //                                 )
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           SizedBox(height: 5,),
                        //                           Divider(color: lightTextColor.withOpacity(0.3),thickness: 1,)
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //               },itemCount: docs.length);
                        //
                        //       }}):
                        // sort[1]['isSelected']==true?
                        // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //     stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                        //         .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        //     searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                        //         .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                        //     searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                        //         .doc(buyRent)
                        //         .collection(buyRent).orderBy('timestamp',descending: true) // Sort by 'createdAt' field in descending order
                        //         .snapshots(),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.connectionState == ConnectionState.waiting) {
                        //         return const Center(
                        //           child: CircularProgressIndicator(),
                        //         );
                        //       } else if (snapshot.hasError) {
                        //         return Text('Error: ${snapshot.error}');
                        //       } else {
                        //         final rootDocs = snapshot.data!.docs;
                        //         var docs = rootDocs.where((doc) {
                        //           var data = doc.data() as Map<String, dynamic>;
                        //
                        //           // Check if the property description contains any of the keywords
                        //           bool containsKeyword = true;
                        //           if(searchProvider.keywordList.isNotEmpty){
                        //             containsKeyword = searchProvider.keywordList.any((keyword) {
                        //               return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                        //             });
                        //           }
                        //           bool containsImages = false;
                        //           if(data['images']!=[]){
                        //             containsImages = true;
                        //           }
                        //
                        //           double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                        //           if( searchProvider.propertyTypeSelected == 'Houses'){
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                        //               return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                        //                   (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                        //                   (containsKeyword && containsImages) &&
                        //                   (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                        //                   ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                       (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                       (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                   ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                       (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                        //                   (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                        //                   (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                   (containsKeyword) &&
                        //                   (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                        //                   ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                       (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                   ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                       (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //           else   if (searchProvider.propertyTypeSelected == 'Plots'){
                        //
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                        //               return
                        //                 (containsKeyword && containsImages) &&
                        //                     (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                        //                     (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return
                        //                 (containsKeyword) &&
                        //                     (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //           else{
                        //             if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                        //               return
                        //                 (containsKeyword && containsImages) &&
                        //                     (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //
                        //             } else {
                        //               return
                        //                 (containsKeyword) &&
                        //                     (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                        //                     ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                        //                         (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                        //                         (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                        //                     ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                        //                         (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                        //             }
                        //           }
                        //
                        //         }).toList();
                        //         docs.sort((a, b) {
                        //           var aData = a.data() as Map<String, dynamic>;
                        //           var bData = b.data() as Map<String, dynamic>;
                        //           double aPrice = double.parse(aData['totalPrice']) ;
                        //           double bPrice = double.parse(bData['totalPrice'] );
                        //           return aPrice.compareTo(bPrice);
                        //         });
                        //
                        //         return
                        //           ListView.builder(
                        //               itemBuilder: (context,index){
                        //                 final data = docs[index].data();
                        //                 return
                        //                   InkWell(onTap: (){
                        //                     try{
                        //                       navigateWithTransition(
                        //                           context, SelectedProperty(
                        //                         images: data['images']!=[]? data['images'] :[data['displayImage']],
                        //                         totalPrice: data['totalPrice'],
                        //                         posterUid: data['uid'],
                        //                         beds: data['bedrooms'],
                        //                         bathrooms: data['bathrooms'],
                        //                         area: data['area'],
                        //                         areaType: data['areaType'],
                        //                         description: data['propertyDescription'],
                        //                         title: data['propertyTitle'], timestamp: data['timestamp'], location: data['location'], docId: data['docId'], displayImage:  data['displayImage'],
                        //                       ), TransitionType.slideRightToLeft);
                        //                     }
                        //                     catch(e){
                        //                       print(e.toString());
                        //                     }
                        //                   },
                        //                     child:
                        //                     Container(
                        //                       color:white,
                        //                       child: Column(
                        //                         mainAxisSize: MainAxisSize.min,
                        //                         children: [
                        //                           Container(
                        //                             padding: EdgeInsets.symmetric(horizontal: 4),
                        //                             width: w,
                        //                             height: 150, decoration: BoxDecoration(
                        //                             color:white,
                        //                             borderRadius: BorderRadius.circular(5),
                        //                           ),
                        //                             alignment: Alignment.center,
                        //                             child: Row(
                        //                               crossAxisAlignment: CrossAxisAlignment.center,
                        //                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                               children: [
                        //                                 ClipRRect(
                        //                                   borderRadius: BorderRadius.circular(5),
                        //                                   child: Image.network(data['displayImage'],width: 140,height: 150,fit: BoxFit.fill,),
                        //                                 ),
                        //                                 SizedBox(width: 6.5,),
                        //                                 Column(
                        //                                   crossAxisAlignment: CrossAxisAlignment.start,
                        //                                   children: [
                        //                                     Row(
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik(getTimeDifference(data['timestamp']), greyShade3, w400, size10),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik('PKR', darkTextColor, w500, size14),
                        //                                         SizedBox(width: 3,),
                        //                                         textRubik(data['totalPrice'], darkTextColor, w600, size18),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       children: [
                        //                                         textRubik((data['location']+ ', '+data['city']).toString().length<=25?(data['location']+ ', '+data['city']):(data['location']+ ', '+data['city']).toString().substring(0,24)+'...', darkTextColor, w500, size15),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Row(
                        //                                       crossAxisAlignment: CrossAxisAlignment.center,
                        //                                       mainAxisAlignment: MainAxisAlignment.start,
                        //                                       children: [
                        //                                         textRubik(data['propertyTitle'], greyShade3, w400, size12),
                        //                                       ],
                        //                                     ),
                        //                                     SizedBox(height: 5,),
                        //                                     Container( width: w-140 - 8-8,
                        //                                       child: Row(
                        //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                                         crossAxisAlignment: CrossAxisAlignment.center,
                        //                                         children: [
                        //                                           Row(
                        //                                             crossAxisAlignment: CrossAxisAlignment.center,
                        //                                             mainAxisSize: MainAxisSize.min ,
                        //                                             children: [
                        //                                               data['bedrooms']!='null'?  Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.bed,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(data['bedrooms'], darkTextColor, w500, size12),
                        //                                                 ],
                        //                                               ):Container(),
                        //                                               SizedBox(width: 5,),
                        //                                               data['bedrooms']!='null'?Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.bathroom_outlined,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(data['bathrooms'], darkTextColor, w500, size12),
                        //                                                 ],
                        //                                               ):Container(),
                        //                                               SizedBox(width: 5,),
                        //                                               Row(
                        //                                                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                                                 children: [
                        //                                                   Icon(Icons.photo_size_select_small_sharp,size: 15,color: darkTextColor,),
                        //                                                   SizedBox(width: 3,),
                        //                                                   textRubik(
                        //                                                       formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
                        //                                                       darkTextColor,
                        //                                                       w500,
                        //                                                       size12
                        //                                                   ),
                        //                                                 ],
                        //                                               ),
                        //                                               SizedBox(width: 5,),
                        //                                             ],
                        //                                           ),
                        //                                           StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        //                                               stream:
                        //                                               FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').where('docId',isEqualTo:data['docId']).snapshots(),
                        //
                        //                                               builder: (context, snapshot) {
                        //                                                 if (snapshot.connectionState == ConnectionState.waiting) {
                        //                                                   return  Center(
                        //                                                     child: CircularProgressIndicator(color: primaryColor,),
                        //                                                   );
                        //                                                 } else if (snapshot.hasError) {
                        //                                                   return Text('Error: ${snapshot.error}');
                        //                                                 } else {
                        //                                                   final docs1 = snapshot.data!.docs;
                        //                                                   // Check if the property description contains any of the keywords
                        //                                                   return
                        //                                                     docs1.length==0?
                        //                                                     InkWell(
                        //                                                         onTap:()async{
                        //                                                           try{
                        //                                                             List<dynamic> likedBy = [];
                        //                                                             likedBy = await data['likedBy']??[];
                        //
                        //                                                             if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                        //                                                               likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                        //                                                             }
                        //                                                             else{
                        //                                                               likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                        //
                        //                                                             await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
                        //                                                                 {
                        //                                                                   'likedBy':FieldValue.arrayUnion(likedBy)
                        //                                                                 });
                        //                                                             await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs [index]['docId']).set({
                        //                                                               'city':data['city'],
                        //                                                               'propertyType':data['propertyType'],
                        //                                                               'purpose':data['purpose'],
                        //                                                               'docId':data['docId'],
                        //                                                               'images':data['images'],
                        //                                                               'displayImage':data['displayImage'],
                        //                                                               'totalPrice':data['totalPrice'],
                        //                                                               'location':data['location'],
                        //
                        //                                                               'area':data['area'],
                        //                                                               'areaType':data['areaType'],
                        //                                                               'bathrooms':data['bathrooms'],
                        //                                                               'bedrooms':data['bedrooms'],
                        //                                                               'propertyDescription':data['propertyDescription'],
                        //                                                               'propertyTitle':data['propertyTitle'],
                        //                                                               'timestamp':data['timestamp'],
                        //                                                               'readyForPossession':data['readyForPossession'],
                        //                                                               'uid':data['uid'],
                        //                                                               'likedBy':data['likedBy'],
                        //                                                             });
                        //                                                           }
                        //                                                           catch(e){
                        //                                                             print(e.toString());
                        //                                                           }
                        //                                                         },
                        //                                                         child: Icon(Icons.favorite,color: lightTextColor,size: 18,)
                        //                                                     ):
                        //                                                     InkWell(
                        //                                                         onTap:()async{
                        //                                                           try{
                        //                                                             List<dynamic> likedBy = [];
                        //                                                             likedBy = await data['likedBy']??[];
                        //
                        //                                                             if(likedBy.contains(FirebaseAuth.instance.currentUser!.uid)){
                        //                                                               likedBy.remove(FirebaseAuth.instance.currentUser!.uid);
                        //                                                             }
                        //                                                             else{
                        //                                                               likedBy.add(FirebaseAuth.instance.currentUser!.uid);}
                        //
                        //                                                             await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
                        //                                                                 {
                        //                                                                   'likedBy':FieldValue.arrayUnion(likedBy)
                        //                                                                 });
                        //
                        //                                                             await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Favorites').doc(docs1 [0]['docId']).delete();
                        //                                                           }
                        //                                                           catch(e){
                        //                                                             print(e.toString());
                        //                                                           }
                        //                                                         },
                        //                                                         child: Icon(Icons.favorite,color: red,size: 18,)
                        //                                                     );
                        //                                                 }}),
                        //                                         ],
                        //                                       ),
                        //                                     ),
                        //                                     SizedBox(height: 8,),
                        //                                     Container(
                        //                                       width: w-140 - 35,
                        //                                       child: Row(
                        //                                         crossAxisAlignment: CrossAxisAlignment.center,
                        //                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //                                         children: [
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try{
                        //                                                 try{
                        //                                                   String phoneNumber = await data['phone'];
                        //                                                   if (phoneNumber.isNotEmpty) {
                        //                                                     String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp URL with phone number
                        //                                                     if (await canLaunch(whatsappUrl)) {
                        //                                                       await launch(whatsappUrl);
                        //                                                     } else {
                        //                                                       throw 'Could not launch $whatsappUrl';
                        //                                                     }
                        //                                                   }
                        //                                                   else{
                        //                                                     throw 'Phone number is empty';
                        //                                                   }
                        //                                                 }
                        //                                                 catch(e){
                        //                                                   print(e.toString());
                        //                                                 }
                        //                                               }
                        //                                               catch(e){
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   color:primaryColor,
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child: Image.asset('assets/whatsapp.png',width: 16,height: 16,fit: BoxFit.cover,color: white,),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try{
                        //                                                 String phoneNumber = await data['phone'];
                        //
                        //                                                 try{
                        //
                        //                                                   if (phoneNumber.isNotEmpty) {
                        //                                                     String phoneCallUrl = "tel:$phoneNumber"; // Phone call URL with phone number
                        //                                                     if (await canLaunch(phoneCallUrl)) {
                        //                                                       await launch(phoneCallUrl);
                        //                                                     } else {
                        //                                                       throw 'Could not launch $phoneCallUrl';
                        //                                                     }
                        //                                                   } else {
                        //                                                     throw 'Phone number is empty';
                        //                                                   }
                        //                                                 }
                        //                                                 catch(e){
                        //                                                   print(e.toString());
                        //                                                 }
                        //                                               }
                        //                                               catch(e){
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   color:primaryColor,
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child: Icon(Icons.call,color: white,),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                           InkWell(
                        //                                             onTap:()async{
                        //                                               try {
                        //
                        //                                                 String phoneNumber = await data['phone'];
                        //
                        //                                                 if (phoneNumber.isNotEmpty) {
                        //                                                   String smsUrl = "sms:$phoneNumber"; // SMS URL with phone number
                        //                                                   if (await canLaunch(smsUrl)) {
                        //                                                     await launch(smsUrl);
                        //                                                   } else {
                        //                                                     throw 'Could not launch $smsUrl';
                        //                                                   }
                        //                                                 } else {
                        //                                                   throw 'Phone number is empty';
                        //                                                 }
                        //                                               } catch(e) {
                        //                                                 print(e.toString());
                        //                                               }
                        //                                             },
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //                                                 child:textRubik('SMS', primaryColor, w500, size14),
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //
                        //                                           InkWell(
                        //                                             onTap:(){
                        //                                               navigateWithTransition(context, ChatScreen(user2Uid: data['uid'],), TransitionType.slideRightToLeft);
                        //                                             },
                        //
                        //                                             child: Container(
                        //                                               width: 38,
                        //                                               height: 35,
                        //                                               alignment: Alignment.center,
                        //                                               decoration: BoxDecoration(
                        //                                                   border: Border.all(color: primaryColor,width: 1),
                        //                                                   borderRadius: BorderRadius.circular(8)
                        //
                        //                                               ),
                        //                                               child: Center(
                        //
                        //                                                   child:Icon(CupertinoIcons.chat_bubble_2,color: primaryColor,)
                        //                                               ),
                        //                                             ),
                        //                                           ),
                        //                                         ],
                        //                                       ),
                        //                                     )
                        //                                   ],
                        //                                 )
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           SizedBox(height: 5,),
                        //                           Divider(color: lightTextColor.withOpacity(0.3),thickness: 1,)
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   );
                        //               },itemCount: docs.length);
                        //
                        //       }}):

                            sort[0]['isSelected']==true?
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                                    .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                                searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                    .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                                searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                    .doc(buyRent)
                                    .collection(buyRent) // Sort by 'createdAt' field in descending order
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final rootDocs = snapshot.data!.docs;
                                    var docs = rootDocs.where((doc) {
                                      var data = doc.data() as Map<String, dynamic>;

                                      // Check if the property description contains any of the keywords
                                      bool containsKeyword = true;
                                      if(searchProvider.keywordList.isNotEmpty){
                                        containsKeyword = searchProvider.keywordList.any((keyword) {
                                          return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                                        });
                                      }
                                      bool containsImages = false;
                                      if(data['images']!=[]){
                                        containsImages = true;
                                      }

                                      double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                                      if( searchProvider.propertyTypeSelected == 'Houses'){
                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                                          return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                              (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                              (containsKeyword && containsImages) &&
                                              (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                              ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                  (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                              ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                  (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                              (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                              (containsKeyword) &&
                                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                              (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                              ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                  (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                              ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                  (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }
                                      else   if (searchProvider.propertyTypeSelected == 'Plots'){

                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                          return
                                            (containsKeyword && containsImages) &&
                                                (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return
                                            (containsKeyword) &&
                                                (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }
                                      else{
                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                          return
                                            (containsKeyword && containsImages) &&
                                                (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return
                                            (containsKeyword) &&
                                                (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }

                                    }).toList();
                                    docs.sort((a, b) {
                                      var aData = a.data() as Map<String, dynamic>;
                                      var bData = b.data() as Map<String, dynamic>;
                                      double aPrice = double.parse(aData['totalPrice']) ;
                                      double bPrice = double.parse(bData['totalPrice'] );
                                      return aPrice.compareTo(bPrice);
                                    });

                                    return
                                      ListView.builder(
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
                                                                                  formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
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

                                                                                        await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                                        await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                      InkWell(   onTap:(){
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

                                  }}):
                            sort[1]['isSelected']==true?
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                                    .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                                searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                    .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                                searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                                    .doc(buyRent)
                                    .collection(buyRent) // Sort by 'createdAt' field in descending order
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final rootDocs = snapshot.data!.docs;
                                    var docs = rootDocs.where((doc) {
                                      var data = doc.data() as Map<String, dynamic>;

                                      // Check if the property description contains any of the keywords
                                      bool containsKeyword = true;
                                      if(searchProvider.keywordList.isNotEmpty){
                                        containsKeyword = searchProvider.keywordList.any((keyword) {
                                          return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                                        });
                                      }
                                      bool containsImages = false;
                                      if(data['images']!=[]){
                                        containsImages = true;
                                      }

                                      double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );
                                      if( searchProvider.propertyTypeSelected == 'Houses'){
                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                                          return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                              (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                              (containsKeyword && containsImages) &&
                                              (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                              ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                  (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                              ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                  (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                              (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                              (containsKeyword) &&
                                              (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                              ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                  (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                              ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                  (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }
                                      else   if (searchProvider.propertyTypeSelected == 'Plots'){

                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                          return
                                            (containsKeyword && containsImages) &&
                                                (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return
                                            (containsKeyword) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }
                                      else{
                                        if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                                          return
                                            (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                (containsKeyword && containsImages) &&
                                                (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                                        } else {
                                          return
                                            (containsKeyword) &&
                                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                                (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                                        }
                                      }

                                    }).toList();
                                    docs.sort((a, b) {
                                      var aData = a.data() as Map<String, dynamic>;
                                      var bData = b.data() as Map<String, dynamic>;
                                      double aPrice = double.parse(aData['totalPrice']) ;
                                      double bPrice =double.parse( bData['totalPrice']) ;
                                      return bPrice.compareTo(aPrice); // Compare in descending order
                                    });

                                    return
                                      ListView.builder(
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
                                                                                  formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
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

                                                                                        await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                                        await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                                                                      InkWell(
                                                                        onTap:(){
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

                                  }}):






                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection(searchProvider.selectedCity)
                          .doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                      searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                          .collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' :
                      searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial')
                          .doc(buyRent)
                          .collection(buyRent)
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
                        var docs = rootDocs.where((doc) {
                          var data = doc.data() as Map<String, dynamic>;

                          // Check if the property description contains any of the keywords
                          bool containsKeyword = true;
                          if(searchProvider.keywordList.isNotEmpty){
                            containsKeyword = searchProvider.keywordList.any((keyword) {
                              return data['propertyDescription'].toString().toLowerCase().contains(keyword.toLowerCase());
                            });
                          }

                          bool containsImages = false;
                          if(data['images']!=[]){
                            containsImages = true;
                          }

                         double areaDocument = double.parse( formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) );

                        if( searchProvider.propertyTypeSelected == 'Houses'){
                          if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Houses') {
                            return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                (containsKeyword && containsImages) &&
                                (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                            ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                // data['location'].toString().contains(searchProvider.)
                                (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                          } else {
                            return (searchProvider.bedroom.isEmpty || data['bedrooms'] == searchProvider.bedroom) &&
                                (searchProvider.bathroom.isEmpty || data['bathrooms'] == searchProvider.bathroom) &&
                                (containsKeyword) &&
                                (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                (searchProvider.housesSelected == 'All' || searchProvider.housesSelected == data['homesPlotsCommercial']) &&
                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                            ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                          }
                        }
                          else   if (searchProvider.propertyTypeSelected == 'Plots'){

                          if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                            return
                              (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                  (containsKeyword && containsImages) &&
                                (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                    (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                          } else {
                            return
                                (containsKeyword) &&
                                    (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                    (searchProvider.plotsSelected == 'All' || searchProvider.plotsSelected == data['homesPlotsCommercial']) &&
                                ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                    (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                    (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                           }
                          }
                          else{
                          if (searchProvider.switchVal && searchProvider.propertyTypeSelected == 'Plots') {
                            return
                              (containsKeyword && containsImages) &&
                                  (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                  (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                  ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                      (searchProvider.maxPrice.isEmpty || double.parse(data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                  ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                      (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));

                          } else {
                            if(sort[0]['isSelected']=='true'){

                            }
                            return
                              (containsKeyword) &&
                                  (searchProvider.commercialSelected == 'All' || searchProvider.commercialSelected == data['homesPlotsCommercial']) &&
                                  (doc['location']==searchProvider.selectedLocation || searchProvider.selectedLocation=='')&&
                                  ((searchProvider.minPrice.isEmpty || double.parse(data['totalPrice']) >= double.parse(searchProvider.minPrice)) &&
                                      (searchProvider.maxPrice.isEmpty || double.parse( data['totalPrice']) <= double.parse(searchProvider.maxPrice)))&&
                                  ((searchProvider.minArea.isEmpty || areaDocument >= double.parse(searchProvider.minArea)) &&
                                      (searchProvider.maxArea.isEmpty || areaDocument <= double.parse(searchProvider.maxArea)));
                          }
                        }

                        }).toList();


                        if (sort[0]['isSelected'] == 'true') {
                          docs.sort((a, b) {
                            var aData = a.data() as Map<String, dynamic>;
                            var bData = b.data() as Map<String, dynamic>;
                            return (aData['likedBy'] as List).length.compareTo((bData['likedBy'] as List).length);
                          });
                        }


                        return
                          ListView.builder(

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
                                                                      formatArea(convertArea(data['areaType'], data['area'], searchProvider.areaType)) + ' ' + searchProvider.areaType,
                                                                      darkTextColor,
                                                                      w500,
                                                                      size12
                                                                  ),


                                                                ],
                                                              ),
                                                              SizedBox(width: 5,),
                                                            ],
                                                          ),
                                                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>> (
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

                                                                            await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
                                                                                {
                                                                                  'likedBy':FieldValue.arrayUnion(likedBy)
                                                                                });

                                                                            await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                                                                {
                                                                                  'favouriteProperties':FieldValue.arrayUnion(likedBy)
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

                                                                            await  FirebaseFirestore.instance.collection(searchProvider.selectedCity).doc(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').collection(searchProvider.propertyTypeSelected == 'Houses' ? 'Homes' : searchProvider.propertyTypeSelected == 'Plots' ? 'Plots' : 'Commercial').doc(buyRent).collection(buyRent).doc(data['docId']).update(
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

                      }});

              },)
              ,
            ),
            SizedBox(height: 40,),

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
