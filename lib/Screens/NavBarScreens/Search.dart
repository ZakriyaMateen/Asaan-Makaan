
import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Constants/FontWeights.dart';
import 'package:asaanmakaan/Screens/CustomNavBar.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/SearchResults.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Constants/FontSizes.dart';
import '../../Providers/SearchProvider.dart';
import 'SelectLocationSearch.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  // Lists
  List<String> propertyType = ['Houses','Plots','Commercial'];
  List<String> bedrooms = ['Studio','1','2','3','4','5','6','7','8','9','10','11','12','13'];
  List<String> bathrooms = ['1','2','3','4','5','6','7'];
  //

  // Strings


  //
  List<Map<String,dynamic>> plots = [
    {'iconData':Icons.done_all,'title':'All'},
    {'iconData':Icons.scatter_plot_outlined,'title':'Residential Plot'},
    {'iconData':Icons.location_searching,'title':'Agricultural Plot'},
    {'iconData':Icons.swap_calls_rounded,'title':'Commercial Plot'},
    {'iconData':Icons.factory_outlined,'title':'Industrial Plot'},
  ];
  List<Map<String,dynamic>> commercials = [
    {'iconData':Icons.done_all,'title':'All'},
    {'iconData':Icons.meeting_room_sharp,'title':'Office'},
    {'iconData':Icons.store,'title':'Shop'},
    {'iconData':Icons.warehouse_outlined,'title':'Warehouse'},
    {'iconData':Icons.factory_outlined,'title':'Factory'},
    {'iconData':Icons.corporate_fare,'title':'Building'},
  ];
  List<Map<String,dynamic>> houses = [
    {
      'iconData':Icons.done_all,
      'title':'All'
    },{
      'iconData':Icons.house_outlined,
      'title':'House'
    },{
      'iconData':Icons.corporate_fare_rounded,
      'title':'Flat'
    },{
      'iconData':Icons.upgrade,
      'title':'Upper Portion'
    },{
      'iconData':Icons.low_priority,
      'title':'Farm House'
    },{
      'iconData':Icons.landslide_rounded,
      'title':'Lower Portion'
    },{
      'iconData':Icons.meeting_room_outlined,
      'title':'Room'
    },{
      'iconData':Icons.pentagon_outlined,
      'title':'Pent House'
    },
  ];
  String citySearchText = '';
  List<String> cities = ['Islamabad', 'Karachi', 'Lahore', 'Quetta', 'Peshawar', 'Rawalpindi', 'Faisalabad', 'Multan', 'Hyderabad', 'Gujranwala', 'Sialkot', 'Bahawalpur', 'Sargodha', 'Sukkur', 'Larkana', 'Sheikhupura', 'Mirpur Khas', 'Gujrat', 'Jhang'];

  //Controllers
    TextEditingController price1Controller = TextEditingController();
    TextEditingController price2Controller = TextEditingController();

    TextEditingController range1Controller = TextEditingController();
    TextEditingController range2Controller = TextEditingController();

    TextEditingController keywordController = TextEditingController();
  //
  bool switchVal = false;
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final provider = Provider.of<SearchProvider>(context);

    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            width: w,
            height: h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                    SizedBox(height: h*0.055,),

                  Padded(
                    w:w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CustomNavBar()));
                              },
                              child: Icon(Icons.arrow_back_ios_new_rounded,color: darkTextColor,size: 16,),
                            ),
                            SizedBox(width: 10,),
                            textRubik('Filters', darkTextColor, w500,size19)
                          ],
                        ),
                        textRubik('Search', white, w400, size15)
                      ],
                    ),
                  ),
               divider(),

                  Padded(
                  w:  w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.published_with_changes_sharp,color: lightTextColor,size: 18,),
                              SizedBox(width: 6,),
                              textRubik('Purpose', darkTextColor, w500, size15),
                            ],
                          ),
                        Container(
                          width: 150,
                          height: 45,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap:(){

                                    provider.updateBuyRent(0,true);
                                    provider.updateBuyRent(1,false);

                                },
                                child: Container(
                                  width: 75,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: provider.buyRent[0]?primaryColor:Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: textRubik('Rent',provider.buyRent[0]?white: lightTextColor,provider.buyRent[0]?w500: w400, size16),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap:(){

                                    provider.updateBuyRent(1,true);
                                    provider.updateBuyRent(0,false);


                                },
                                child: Container(
                                  width: 75,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: provider.buyRent[1]?primaryColor:Colors.transparent,
                                  ),
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: textRubik('Buy',provider.buyRent[1]?white: lightTextColor,provider.buyRent[1]?w500: w400, size16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  divider(),
                  Padded(
                    w:w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          // onTap:
                          // provider.selectedLocation.isNotEmpty?(){}:
                          // (){
                          //   showModalBottomSheet(backgroundColor: white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),context: context, builder: (context){
                          //     return StatefulBuilder(builder: (context,StateSetter setStat){
                          //       return Container(
                          //           width: w,
                          //           height: h*0.75,
                          //           decoration: BoxDecoration(
                          //             color: white,
                          //             borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          //           ),
                          //           padding: EdgeInsets.only(left: w*0.05,right: w*0.05,top: 25),
                          //           child: SingleChildScrollView(
                          //             child: Column(
                          //               children: [
                          //                 Row(
                          //                   children: [
                          //                     textRoboto('City : '+' -- ', primaryColor, w500, size18),
                          //                   ],
                          //                 ),
                          //                 SizedBox(height: 7,),
                          //                 TextFormField(
                          //                   style:GoogleFonts.roboto(
                          //                     textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                          //                   ),
                          //                   onChanged:(v){
                          //                      setStat((){
                          //                        citySearchText = v!;
                          //                      });
                          //
                          //                   },
                          //                   decoration: InputDecoration(
                          //                     hintText: 'Search City',
                          //                     hintStyle:GoogleFonts.roboto(
                          //                       textStyle: TextStyle(color: greyShade2, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                          //                     ),
                          //                     border: OutlineInputBorder(
                          //                         borderRadius: BorderRadius.circular(55),
                          //                         borderSide: BorderSide(color: greyShade2,width: 1)
                          //                     ),
                          //                     enabledBorder:  OutlineInputBorder(
                          //                         borderRadius: BorderRadius.circular(55),
                          //                         borderSide: BorderSide(color: greyShade2,width: 1)
                          //                     ),
                          //                     focusedBorder:  OutlineInputBorder(
                          //                         borderRadius: BorderRadius.circular(55),
                          //                         borderSide: BorderSide(color: primaryColor,width: 1)
                          //                     ),
                          //
                          //                   ),
                          //                 ),
                          //                 SizedBox(height: 8,),
                          //                 ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){
                          //                   // Filter the list based on searchText
                          //                   List<String> filteredCities = cities
                          //                       .where((city) =>
                          //                       city.toLowerCase().contains(citySearchText.toLowerCase()))
                          //                       .toList();
                          //                   if (index >= 0 && index < filteredCities.length) {
                          //                     return GestureDetector(
                          //                       onTap: (){
                          //                           provider.updateSelectedCity( filteredCities[index]) ;
                          //                         Navigator.pop(context);
                          //                       },
                          //                       child: Container(
                          //                         width: w,
                          //                         height: 45,
                          //                         child: Row(
                          //                           crossAxisAlignment: CrossAxisAlignment.center,
                          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //                           children: [
                          //                             textRoboto(filteredCities[index], darkTextColor, w500, size16)
                          //                           ],
                          //                         ),
                          //                       ),
                          //                     );}
                          //                   else{
                          //                     return Container();
                          //                   }
                          //
                          //                 },itemCount:cities.length)
                          //               ],
                          //             ),
                          //           )
                          //       );
                          //     });
                          //   });
                          // },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined,color: lightTextColor,size: 18,),
                              SizedBox(width: 6,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  textRubik('City', darkTextColor, FontWeight.w500, 15),
                                  SizedBox(height: 2),
                                  textRubik(
                                    provider.selectedLocation.isEmpty
                                        ? provider.selectedCity
                                        : provider.selectedLocation.contains(',')
                                        ? provider.selectedLocation.split(',').last.trim()
                                        : '',
                                    primaryColor,
                                    FontWeight.w500,
                                    15,
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,color: darkTextColor,size: 16,)
                      ],
                    ),
                  ),
                  divider(),
                  Padded(
                      w: w, child: GestureDetector(

                    onTap:(){
                        navigateWithTransition(context, SelectLocationSearch(), TransitionType.slideRightToLeft);
                    },
                        child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Icon(Icons.map_outlined,color: lightTextColor,size: 18,),
                        SizedBox(width: 6,),
                        textRubik( provider.selectedLocation==''?'Location':
                        provider.selectedLocation.length>=28?provider.selectedLocation.substring(0,27):provider.selectedLocation, darkTextColor,FontWeight.w500, size15),
                    ],
                  ),
                      )
                  ),
                  divider(),
                  Padded(
                    w:w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.corporate_fare_rounded,color: lightTextColor,size: 18,),
                        SizedBox(width: 6,),
                        textRubik('Property Type', darkTextColor,FontWeight.w500,size15),
                      ],
                    ),
                  ),
                  SizedBox(height:10,),

                  Padded(
                    w: w,
                    child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [

                          GestureDetector(
                            onTap:(){
                                provider.updatePropertyTypeSelected('Houses');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textRubik('Houses',provider.propertyTypeSelected=='Houses'? primaryColor: darkTextColor, w500, size14),
                                SizedBox(height: 3,),
                                Container(
                                  width: 90,
                                  height: 2,
                                  decoration: BoxDecoration(
                                      color:provider.propertyTypeSelected=='Houses'?primaryColor: white,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                  ),
                                ),
                              ],
                            ),
                          ),  GestureDetector(
                            onTap:(){

                                provider.updatePropertyTypeSelected ('Plots');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textRubik('Plots', provider.propertyTypeSelected=='Plots'? primaryColor: darkTextColor, w500, size14),
                                SizedBox(height: 3,),
                                Container(
                                  width: 90,
                                  height: 2,
                                  decoration: BoxDecoration(
                                      color:provider.propertyTypeSelected=='Plots'?  primaryColor:white,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                  ),
                                ),
                              ],
                            ),
                          ),  GestureDetector(
                            onTap:(){
                              provider.updatePropertyTypeSelected ('Commercial');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                textRubik('Commercial', provider.propertyTypeSelected=='Commercial'? primaryColor: darkTextColor, w500, size14),
                                SizedBox(height: 3,),
                                Container(
                                  width: 90,
                                  height: 2,
                                  decoration: BoxDecoration(
                                      color:provider.propertyTypeSelected=='Commercial'? primaryColor: white,
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 16,),
                  provider.propertyTypeSelected == 'Houses'?
                      Container(
                        height: 34,
                        width: w,
                        child: ListView.builder(itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){

                                provider.updateHousesSelected( houses[index]['title']) ;
                            },
                            child: Container(
                              height: 34,
                              margin: EdgeInsets.only(right: 7,left: index==0?w*0.05:0),
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: provider.housesSelected == houses[index]['title']?primaryColor.withOpacity(0.1):greyShade3.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(35),
                                border: Border.all(color: provider.housesSelected == houses[index]['title']?primaryColor:greyShade3.withOpacity(0.4),width: 1)
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(houses[index]['iconData'],size: 17,color: provider.housesSelected == houses[index]['title']?primaryColor:darkTextColor ,),
                                  SizedBox(width: 2.5,),
                                  textRubik(houses[index]['title'],provider.housesSelected == houses[index]['title']?primaryColor:darkTextColor , w500, size15)
                                ],
                              ),
                            ),
                          );
                        },itemCount: houses.length,scrollDirection: Axis.horizontal,),
                      ):provider.propertyTypeSelected == 'Plots'?
                  Container(
                    height: 34,
                    width: w,
                    child: ListView.builder(itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                            provider.updatePlotsSelected( plots[index]['title']) ;
                        },
                        child: Container(
                          height: 34,
                          margin: EdgeInsets.only(right: 7,left: index==0?w*0.05:0),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: provider.plotsSelected == plots[index]['title']?primaryColor.withOpacity(0.1):greyShade3.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(color: provider.plotsSelected == plots[index]['title']?primaryColor:greyShade3.withOpacity(0.4),width: 1)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(plots[index]['iconData'],size: 17,color:provider. plotsSelected == plots[index]['title']?primaryColor:darkTextColor ,),
                              SizedBox(width: 2.5,),
                              textRubik(plots[index]['title'],provider.plotsSelected == plots[index]['title']?primaryColor:darkTextColor , w500, size15)
                            ],
                          ),
                        ),
                      );
                    },itemCount: plots.length,scrollDirection: Axis.horizontal,),
                  ):provider.propertyTypeSelected == 'Commercial'?
                  Container(
                    height: 34,
                    width: w,
                    child: ListView.builder(itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                           provider.updateCommercialSelected( commercials[index]['title']) ;
                        },
                        child: Container(
                          height: 34,
                          margin: EdgeInsets.only(right: 7,left: index==0?w*0.05:0),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: provider.commercialSelected == commercials[index]['title']?primaryColor.withOpacity(0.1):greyShade3.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(35),
                              border: Border.all(color:provider. commercialSelected == commercials[index]['title']?primaryColor:greyShade3.withOpacity(0.4),width: 1)
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(commercials[index]['iconData'],size: 17,color: provider.commercialSelected == commercials[index]['title']?primaryColor:darkTextColor ,),
                              SizedBox(width: 2.5,),
                              textRubik(commercials[index]['title'],provider.commercialSelected == commercials[index]['title']?primaryColor:darkTextColor , w500, size15)
                            ],
                          ),
                        ),
                      );
                    },itemCount: commercials.length,scrollDirection: Axis.horizontal,),
                  ):Container(),

                  SizedBox(height:8),

                  Padded(w: w, child:

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.price_check_rounded,color: lightTextColor,size: 18,),
                          SizedBox(width: 4,),
                          textRubik('Price Range', darkTextColor, w500, size16)
                        ],
                      ),
                      textRubik('PKR', darkTextColor, w500, size16)
                    ],
                  )),
                  SizedBox(height: 6,),

                  Padded(w: w, child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: TextFormField(
                            controller: price1Controller,
                        decoration: InputDecoration(
                          hintText: '0',
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
                        onChanged: (v){
                              provider.updateMinPrice(v!);
                        },
                        style:GoogleFonts.roboto(
                          textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                        ),
                      )),
                      SizedBox(width: 5,),
                      textRubik('TO', darkTextColor, w500, size16),
                      SizedBox(width: 5,),
                      Flexible(child: TextFormField(

                        controller: price2Controller,
                        decoration: InputDecoration(
                          hintText: 'Any',
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
                        onChanged: (v){
                          provider.updateMaxPrice(v!);
                        },
                        style:GoogleFonts.roboto(
                          textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                        ),
                      ))
                    ],
                  )),
                  SizedBox(height: 10,),

                  divider(),
                  Padded(
                    w:w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [    Icon(Icons.photo_size_select_small,color: lightTextColor,size: 15,),
                            SizedBox(width: 5,),
                            textRubik('Area Range', darkTextColor, w500, size18),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // textRubik(areaType, darkTextColor, w500, size18),
                            // SizedBox(width: 4,),
                            DropdownButton(
                                value: provider.areaType,
                                icon: Icon(Icons.arrow_drop_down,color: primaryColor,size: 20,),
                                items: [
                                  DropdownMenuItem(child: textRoboto('Sq. Ft.', darkTextColor, w400, size16),value: 'Sq. Ft.',),
                                  DropdownMenuItem(child: textRoboto('Sq. Yd.', darkTextColor, w400, size16),value: 'Sq. Yd.',),
                                  DropdownMenuItem(child: textRoboto('Marla', darkTextColor, w400, size16),value: 'Marla',),
                                  DropdownMenuItem(child: textRoboto('Kanal', darkTextColor, w400, size16),value: 'Kanal',),
                                ], onChanged: (v){

                              provider.updateAreaType(v!);

                            })
                          ],
                        )
                        ],
                    ),
                  ),

                  SizedBox(height: 8,),
                  Padded(w: w, child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: TextFormField(
                            controller: range1Controller,
                            onChanged: (v){
                              provider.updateMinArea(v);
                            },
                            decoration: InputDecoration(
                              hintText: '0',
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
                        controller: range2Controller,
                        onChanged: (v){
                          provider.updateMaxArea(v);
                        },
                        decoration: InputDecoration(
                          hintText: 'Any',
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
                  )),
                  provider.propertyTypeSelected=='Houses'?divider():Container(),

                  provider.propertyTypeSelected=='Houses'?Padded(
                    w: w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bed,color: lightTextColor,size: 18,),
                        SizedBox(width: 5,),
                        textRubik('Bedrooms', darkTextColor, w500, size18),
                      ],
                    ),
                  ):Container(),
                  provider.propertyTypeSelected=='Houses'? SizedBox(height: 10,):Container(),
                  provider.propertyTypeSelected=='Houses'?  Padded(w: w, child:

                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    alignment: WrapAlignment.start,
                    runSpacing: 7,
                    spacing: 7,
                    direction: Axis.horizontal,
                    children: List.generate(bedrooms.length, (index){
                      return
                        GestureDetector(
                          onTap: (){

                              provider.updateBedroom (bedrooms[index]);

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(color: provider.bedroom == bedrooms[index]? primaryColor:greyShade2,width: 1),
                                    color: provider.bedroom == bedrooms[index]?primaryColor.withOpacity(0.3):greyShade2
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    textRubik(bedrooms[index],provider.  bedroom == bedrooms[index]? primaryColor:darkTextColor, w500, size16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                    }),
                  ),
                  ):Container(),
                  divider(),

                  provider.propertyTypeSelected=='Houses'?     Padded(
                    w: w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.bathroom_outlined,color: lightTextColor,size: 18,),
                        SizedBox(width: 5,),
                        textRubik('Bathrooms', darkTextColor, w500, size18),
                      ],
                    ),
                  ):Container(),
                  provider.propertyTypeSelected=='Houses'? SizedBox(height: 10,):Container(),
                  provider.propertyTypeSelected=='Houses'?Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    alignment: WrapAlignment.start,
                    runSpacing: 7,
                    spacing: 7,
                    direction: Axis.horizontal,
                    children: List.generate(bathrooms.length, (index){
                      return
                        GestureDetector(
                          onTap: (){

                            provider.updateBathroom ( bathrooms[index]);

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(color: provider.bathroom == bathrooms[index]? primaryColor:greyShade2,width: 1),
                                    color: provider.bathroom == bathrooms[index]?primaryColor.withOpacity(0.3):greyShade2
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    textRubik(bathrooms[index],  provider.bathroom == bathrooms[index]? primaryColor:darkTextColor, w500, size16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                    }),
                  ):Container(),
                  provider.propertyTypeSelected=='Houses'? divider():Container(),
                  SizedBox(height: 10,),

                  Padded(
                    w: w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.text_format_rounded,color: lightTextColor,size: 18,),
                        SizedBox(width: 5,),
                        textRubik('Add Keyword', darkTextColor, w500, size16)
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padded(
                    w:w,
                    child:
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: TextFormField(

                                controller: keywordController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Keyword',
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
                                onFieldSubmitted:
                                (v){


                                  keywordController.text.isNotEmpty?   provider.addToKeywordList( keywordController.text.toString()):null;
                                  keywordController.text.isNotEmpty?keywordController.clear():null;
                                },
                                style:GoogleFonts.roboto(
                                  textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                ),
                              )),
                          SizedBox(width: 4,),
                          InkWell(
                            onTap:
                                (){
                                  keywordController.text.isNotEmpty?  provider.addToKeywordList( keywordController.text.toString()):null;
                                  keywordController.text.isNotEmpty?keywordController.clear():null;

                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: lightTextColor,width: 1)
                              ),
                              child: Center(
                                child: Icon(Icons.add,color: primaryColor,size: 17,),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                  provider.keywordList.isNotEmpty?SizedBox(height: 8,):Container(),
                  provider.keywordList.isNotEmpty?        Container(
                    height: 35,
                    width:w,
                    child: Padded(w: w, child: ListView.builder(
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.only(right: 7),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          height: 35,
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            border: Border.all(color: primaryColor,width:1),
                            borderRadius: BorderRadius.circular(40)
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textRubik(provider.keywordList[index], primaryColor, w400, size16),
                              SizedBox(width: 3,),
                              GestureDetector(
                                  onTap:(){

                                      provider.removeFromKeywordList(provider.keywordList[index]);

                                  },
                                  child: Icon(Icons.close,color:primaryColor,size: 15,)),
                            ],
                          ),
                        );
                      },
                      itemCount: provider.keywordList.length,
                      scrollDirection: Axis.horizontal,
                    )),
                  ):Container(),

                  divider(),

                  Padded(
                    w:w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,color:lightTextColor,size:15),
                            SizedBox(width:5),
                            textRubik('Show ads with images only', darkTextColor, w500, size18),
                          ],
                        ),
                        Switch(value: provider.switchVal, onChanged: (v){

                          provider.updateSwitchVal ( v);
                        },
                          activeTrackColor: MaterialStateColor.resolveWith((states) => Colors.grey[200]!),
                          inactiveTrackColor: MaterialStateColor.resolveWith((states) => lightTextColor),
                          thumbColor: MaterialStateColor.resolveWith((states) => primaryColor),)
                      ],
                    )
                  ),
                  divider(),
                  SizedBox(height: h*0.045,),



                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: w,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: grey,width:1))
                // borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
              ),
              alignment: Alignment.center,
              child: Padded(
                w:w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap:(){

                            price1Controller.text='0';
                            price2Controller.text='Any';
                            range1Controller.text='0';
                            range2Controller.text='Any';
                            provider.updateHousesSelected ( 'All');
                            provider.updatePlotsSelected ( 'All');
                            provider.updateCommercialSelected  ('All');
                            provider.updatePropertyTypeSelected ('Houses');
                            provider.updateBuyRent(0, true);
                            provider.updateBuyRent(1, false);
                            provider.clearKeywordList();
                            provider.clearSelectedLocation();
                        },
                        child: textRubik('Reset All', lightTextColor,w500, size16)),
                    InkWell(
                      onTap:(){
                        // if(provider.selectedLocation==''){
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Please choose a Location!', white,w400, size17)));
                        // }
                        // else{
                          navigateWithTransition(context, SearchResults(), TransitionType.slideTopToBottom);
                        // }
                      },
                      child: Container(
                        width: w*0.5,
                        height: 45,
                        decoration: BoxDecoration(
                          color:primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child:textRubik('Show Results', white, w500, size19)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget Padded ({required double w,required Widget child}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:w*0.05),
      child: child,
    );
  }
  Widget divider(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height:7,),
        Divider(thickness:1,
          color: lightTextColor.withOpacity(0.2),
        ),
        SizedBox(height:7,),
      ],
    );
  }
}
