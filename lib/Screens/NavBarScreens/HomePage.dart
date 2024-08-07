import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/Search.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/HomePageSearchProvider.dart';
import '../../Utils/Transitions.dart';
import 'AddPost_navigated.dart';
import 'ChatScreens/ChatContacts.dart';
import 'SearchResultsFromHomePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<String> typeHouses = ['Houses','Flats','Upper Portion','Lower Portion','Farmhouse','Penthouse','Room'];
  List<String> locationHouses = ['Islamabad', 'Karachi', 'Lahore', 'Quetta', 'Peshawar', 'Faisalabad', 'Multan', 'Gujranwala', 'Sialkot', 'Bahawalpur', 'Sargodha', 'Sheikhupura', 'Jhang'];
  List<String> areaSizeHouses = ['5 Marla','3 Marla','7 Marla','8 Marla','10 Marla','1 Kanal','2 Kanal'];

  List<String> typePlots = ['Residential','Commercial','File','Form','Agricultural','Industrial'];
  List<String> locationPlots = ['Islamabad', 'Karachi', 'Lahore', 'Quetta', 'Peshawar', 'Faisalabad', 'Multan', 'Gujranwala', 'Sialkot', 'Bahawalpur', 'Sargodha', 'Sheikhupura', 'Jhang'];
  List<String> areaSizePlots = ['3 Marla','5 Marla','10 Marla','2 Marla','1 Kanal'];

  List<String> typeCommercial = ['Office','Shop','Building','Warehouse','Factory','Other'];
  List<String> locationCommercial = ['Islamabad', 'Karachi', 'Lahore', 'Quetta', 'Peshawar', 'Faisalabad', 'Multan', 'Gujranwala', 'Sialkot', 'Bahawalpur', 'Sargodha', 'Sheikhupura', 'Jhang'];
  List<String> areaSizeCommercial = ['1 Kanal','2 Kanal','5 Marla','10 Kanal','3 Marla'];




  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final provider = Provider.of<HomePageSearchProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(

        child: WidgetAnimator(
          atRestEffect: WidgetRestingEffects.fidget(),
          incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
          outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
          child:Icon(CupertinoIcons.chat_bubble_2,color: white,size: size20,weight: 2,),
        ),
        onPressed: (){
          navigateWithTransition(context, ChatContacts(), TransitionType.slideTopToBottom);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(200)
        ),
        backgroundColor: primaryColor,
      ),
      key: scaffoldKey,
      backgroundColor:  primaryColor.withOpacity(0.2),
      body: Stack(
        children: [

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Container(
                height: 200,
                width: 100,
                color: greyShade2,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Container(
                height: 200,
                width: 100,
                color: primaryColor,
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Stack(
              children: [

                Container(
                  width: w,
                  height: 300,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(35))
                  ),
                ),

              ],
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:  EdgeInsets.only(top: 18),

              child: WidgetAnimator(
                atRestEffect: WidgetRestingEffects.wave(),
                incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
                child:SvgPicture.asset('assets/PakistanBg.svg',width: w,height: h*0.3,fit: BoxFit.cover,color: primaryColorLightForSvg.withOpacity(0.8)
              ),),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:  EdgeInsets.only(top: 43,left: w*0.05,right:w*0.05),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: (){
                      Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu,color: white,)),
                  SizedBox(width: 7,),
                  GestureDetector(
                    onTap:(){
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Search()));
                      navigateWithTransition(context, Search(),TransitionType.slideTopToBottom);
                    },
                    child: Container(
                      width: w*0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(90)
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.search_outlined,color: greyShade3,size: size18,),
                              SizedBox(width: 4,),
                              TyperAnimatedTextKit(
                                // totalRepeatCount: 3,
                                speed: Duration(milliseconds: 150),
                                isRepeatingAnimation: true,
                                text: ['Search for Properties'],
                                textStyle: GoogleFonts.rubik(
                                  fontSize: size14,
                                  fontWeight: w400,
                                  color: greyShade2,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     textRubik('Lahore', lightTextColor, w400, size14)
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child:  Padding(
              padding:  EdgeInsets.only(right: w*0.05,top: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start  ,
                children: [
                  Container(
                    margin:EdgeInsets.only(bottom: 15),
                    width: 130,height: 45,
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(90)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(

                          onTap: (){
                            provider.updateBuyRent('Buy');
                          },child: Container(
                          width: 65,
                          height: 45,
                          decoration: BoxDecoration(
                              color: provider.buyRent == 'Buy'? white:Colors.transparent,
                              borderRadius: BorderRadius.circular(90)
                          ),
                          child: Center(
                            child: textRubik('Buy', provider.buyRent == 'Buy'? primaryColor:lightTextColor, FontWeight.w400, size15),
                          ),
                        ),
                        ), GestureDetector(
                          onTap: (){
                            provider.updateBuyRent('Rent');
                          },
                          child: Container(
                            width: 65,
                            height: 45,
                            decoration: BoxDecoration(
                                color: provider.buyRent == 'Rent'? white:Colors.transparent,
                                borderRadius: BorderRadius.circular(90)
                            ),
                            child: Center(
                              child: textRubik('Rent', provider.buyRent == 'Rent'? primaryColor:lightTextColor, FontWeight.w400, size15),
                            ),
                          ),
                        )
                      ],
                    ),

                  )
                ],
              ),
            ),
          ),

          Align(alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 300),
            child: Container(
              width: w,
              height: h-300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
                color: greyShade2,
              ),
              padding: EdgeInsets.only(top: 18),
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: w*0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: w,
                        height: h*0.48,
                        margin: EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                        ),
                        padding: EdgeInsets.only(top: 14,left: w*0.035,right: w*0.035,bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(children:
                            [
                              textRoboto('Search Properties', darkTextColor, w500, size15)
                              // TextAnimator(
                              //   "Search Properties",
                              //   atRestEffect: WidgetRestingEffects.slide(delay: Duration(seconds: 2),duration: Duration(seconds: 10)),
                              //   incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
                              //   outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
                              //   style: TextStyle(fontSize:size15, fontWeight: w500,color:darkTextColor.withOpacity(0.9)),
                              // ),
                              // TyperAnimatedTextKit(
                              //   speed: Duration(milliseconds: 150),
                              //   isRepeatingAnimation: true,
                              //   text: ['Search Properties'],
                              //   textStyle: GoogleFonts.rubik(
                              //     fontSize: size15,
                              //     fontWeight: w500,
                              //     color: darkTextColor,
                              //   ),
                              // ),
                            ],),
                            SizedBox(height: 16,),
                            propertyTypeRow(provider),
                            SizedBox(height: 12,),
                            typeRow(w,provider),
                            SizedBox(height: 16,),
                            provider.propertyType == 'Houses'?
                            housesWidget(w,provider):
                            provider.propertyType == 'Plots'?
                            plotsWidget(w,provider):
                            commercialWidget(w,provider),
                            ],
                        ),
                      ) ,
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
                                    // TyperAnimatedTextKit(
                                    //   speed: Duration(milliseconds: 150),
                                    //   isRepeatingAnimation: true,
                                    //   text: ['Sell or rent out your property?'],
                                    //   textStyle: GoogleFonts.rubik(
                                    //     fontSize: size15,
                                    //     fontWeight: w500,
                                    //     color: darkTextColor.withOpacity(0.9),
                                    //   ),
                                    // ),
                                  textRoboto('Sell or rent out your property?', darkTextColor.withOpacity(0.9), w500, size15)

                                    // TextAnimator(
                                    //   "Sell or rent out your property?",
                                    //   atRestEffect: WidgetRestingEffects.bounce(),
                                    //   incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(),
                                    //   outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToTop(),
                                    //   style: TextStyle(fontSize: size15, fontWeight: w500,color: darkTextColor),
                                    // ),

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
                ),
              ),
            ),
          ),)

        ],
      )
    );
  }
  Widget commercialWidget(double w,HomePageSearchProvider provider){
    return        Container(
        height: 150,
        width: w,
        alignment: Alignment.center,
        child:  Wrap(
          spacing: 7,
          runSpacing: 7,
          children:  List.generate(provider.commercialSelected=='Type'?typeCommercial.length:provider.commercialSelected=='Location'?locationCommercial.length:areaSizeCommercial.length, (index) {
            return InkWell(

              onTap: (){
                provider.commercialSelected=='Type'?provider.updateType(typeCommercial[index]):
                    provider.commercialSelected=='Location'?provider.updateLocation(locationCommercial[index]):
                        provider.updateAreaSize(areaSizeCommercial[index]);

                navigateWithTransition(context, SearchResultsFromHomePage(), TransitionType.slideRightToLeft);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: greyShade2,width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textCenter(provider.commercialSelected=='Type'?typeCommercial[index]:provider.commercialSelected=='Location'?locationCommercial[index]:areaSizeCommercial[index], darkTextColor, w400, size11),
                    SizedBox(height: 2,),
                    textCenter(provider.plotsSelected, lightTextColor, w400, size9),
                  ],
                ),
              ),
            );
          }),
        )
    );
  }

  Widget plotsWidget(double w,HomePageSearchProvider provider){
    return        Container(
        height: 150,
        width: w,
        alignment: Alignment.center,
        child:  Wrap(
          spacing: 7,
          runSpacing: 7,
          children:  List.generate(provider.plotsSelected=='Type'?typePlots.length:provider.plotsSelected=='Location'?locationPlots.length:areaSizePlots.length, (index) {
            return InkWell(

              onTap: (){
                provider.plotsSelected=='Type'?provider.updateType(typePlots[index]):
                    provider.plotsSelected == 'Location'?provider.updateLocation(locationPlots[index]):
                        provider.updateAreaSize(areaSizePlots[index]);
                navigateWithTransition(context, SearchResultsFromHomePage(), TransitionType.slideRightToLeft);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: greyShade2,width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textCenter(provider.plotsSelected=='Type'?typePlots[index]:provider.plotsSelected=='Location'?locationPlots[index]:areaSizePlots[index], darkTextColor, w400, size11),
                    SizedBox(height: 2,),
                    textCenter(provider.plotsSelected, lightTextColor, w400, size9),
                  ],
                ),
              ),
            );
          }),
        )
    );
  }

  Widget housesWidget(double w,HomePageSearchProvider provider){
    return        Container(
        height: 150,
        width: w,
        alignment: Alignment.center,
        child:  Wrap(
          spacing: 7,
          runSpacing: 7,
          children:  List.generate(provider.housesSelected=='Type'?typeHouses.length:provider.housesSelected=='Location'?locationHouses.length:areaSizeHouses.length, (index) {
            return InkWell(
              onTap: (){
                provider.housesSelected=='Type'?provider.updateType(typeHouses[index]):
                provider.housesSelected=='Location'?provider.updateLocation(locationHouses[index]):
                provider.updateAreaSize(areaSizeHouses[index]);
                navigateWithTransition(context, SearchResultsFromHomePage(), TransitionType.slideRightToLeft);

              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: greyShade2,width: 1)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textCenter(provider.housesSelected=='Type'?typeHouses[index]:provider.housesSelected=='Location'?locationHouses[index]:areaSizeHouses[index], darkTextColor, w400, size11),
                    SizedBox(height: 2,),
                    textCenter(provider.propertyType, lightTextColor, w400, size9),
                  ],
                ),
              ),
            );
          }),
        )
    );
  }
  Widget propertyTypeRow(HomePageSearchProvider provider){
    return      Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                provider.updatePropertyType('Houses');

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined,color: provider.propertyType == 'Houses'? primaryColor:lightTextColor,size: size18,),
                  SizedBox(width: 3,),
                  textRubik('Houses',  provider.propertyType == 'Houses'? primaryColor:lightTextColor, w400, size16),
                ],
              ),
            ),
            SizedBox(height: 4.5,),
            Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                  color: provider.propertyType == 'Houses'? primaryColor:white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            InkWell(
              onTap: (){
                provider.updatePropertyType('Plots');

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.my_location_rounded,color: provider.propertyType== 'Plots'? primaryColor:lightTextColor,size: size18,),
                  SizedBox(width: 3,),
                  textRubik('Plots',  provider.propertyType == 'Plots'? primaryColor:lightTextColor, w400, size16),
                ],
              ),
            ),   SizedBox(height: 4.5,),
            Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                  color: provider.propertyType == 'Plots'? primaryColor:white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,

          children: [
            InkWell(
              onTap: (){
                provider.updatePropertyType('Commercial');

              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.corporate_fare,color: provider.propertyType == 'Commercial'? primaryColor:lightTextColor,size: size18,),
                  SizedBox(width: 3,),
                  textRubik('Commercial',  provider.propertyType == 'Commercial'? primaryColor:lightTextColor, w400, size16),
                ],
              ),
            ),   SizedBox(height: 4.5,),
            Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                  color: provider.propertyType == 'Commercial'? primaryColor:white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
              ),
            ),
          ],
        ),

      ],
    );
  }

  Widget typeRow(double w,HomePageSearchProvider provider){
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: w*0.045),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          InkWell(
            onTap: (){
              if(provider.propertyType == 'Houses'){
                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('Type');

              }
              else if(provider.propertyType == 'Plots'){
                provider.updatePlotsSelected('Type');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('');

              }
              else if(provider.propertyType == 'Commercial'){
                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('Type');
                provider.updateHousesSelected('');


              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: provider.housesSelected == 'Type'?primaryColor.withOpacity(0.1):provider.plotsSelected == 'Type'?primaryColor.withOpacity(0.1):provider.commercialSelected == 'Type'?primaryColor.withOpacity(0.1):Colors.white,
                  borderRadius: BorderRadius.circular(80)
              ),
              child: Center(
                child: textRubik('Type', primaryColor, w400, size15),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              if(provider.propertyType == 'Houses'){
                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('Location');

              }
              else if(provider.propertyType == 'Plots'){
                provider.updatePlotsSelected('Location');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('');


              }
              else if(provider.propertyType == 'Commercial'){
                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('Location');
                provider.updateHousesSelected('');

              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: provider.housesSelected == 'Location'?primaryColor.withOpacity(0.1):provider.plotsSelected == 'Location'?primaryColor.withOpacity(0.1):provider.commercialSelected == 'Location'?primaryColor.withOpacity(0.1):Colors.white,
                  borderRadius: BorderRadius.circular(80)
              ),
              child: Center(
                child: textRubik('Location', primaryColor, w400, size15),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              if(provider.propertyType == 'Houses'){
                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('Area Size');
              }
              else if(provider.propertyType == 'Plots'){
                provider.updatePlotsSelected('Area Size');
                provider.updateCommercialSelected('');
                provider.updateHousesSelected('');

              }
              else if(provider.propertyType == 'Commercial'){

                provider.updatePlotsSelected('');
                provider.updateCommercialSelected('Area Size');
                provider.updateHousesSelected('');

              }

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(
                  color: provider.housesSelected == 'Area Size'?primaryColor.withOpacity(0.1):provider.plotsSelected == 'Area Size'?primaryColor.withOpacity(0.1):provider.commercialSelected == 'Area Size'?primaryColor.withOpacity(0.1):Colors.white,
                  borderRadius: BorderRadius.circular(80)
              ),
              child: Center(
                child: textRubik('Area Size', primaryColor, w400, size15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
