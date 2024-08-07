import 'dart:io';

import 'package:asaanmakaan/Firebase/AddPostFunctions.dart';
import 'package:asaanmakaan/Providers/AddPostProvider.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../../Constants/Color.dart';
import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import 'SelectLocationAddPost.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {


  List<String> imageUrls = [];


  // Lists
  List<String> propertyTypeOptionsHomesList= ['House','Flat','Upper Portion','Lower Portion','Farm House','Room','Pent House'];
  List<String> propertyTypeOptionsPlotsList= ['Residential Plot','Commercial Plot','Agricultural Plot','Industrial Plot','Plot File','Plot Form'];
  List<String> propertyTypeOptionsCommercialList= ['Office','Shop','Warehouse','Factory','Building','Other'];
  List<IconData> propertTypeIconsHomesList = [CupertinoIcons.house, Icons.corporate_fare, CupertinoIcons.arrow_merge, CupertinoIcons.arrow_down_right, Icons.warehouse, Icons.meeting_room, Icons.houseboat_outlined];
  List<IconData> propertTypeIconsPlotsList = [Icons.location_on_outlined, Icons.monetization_on_outlined, Icons.holiday_village_outlined, Icons.account_tree_outlined, Icons.file_copy_outlined, CupertinoIcons.person_crop_circle_fill_badge_exclam];
  List<IconData> propertTypeIconsCommercialList = [Icons.local_convenience_store_outlined, Icons.shopping_bag_outlined, Icons.warehouse_outlined, Icons.factory_outlined, Icons.corporate_fare_rounded, Icons.more];
  List<String> cities = ['Islamabad', 'Karachi', 'Lahore', 'Quetta', 'Peshawar', 'Rawalpindi', 'Faisalabad', 'Multan', 'Hyderabad', 'Gujranwala', 'Sialkot', 'Bahawalpur', 'Sargodha', 'Sukkur', 'Larkana', 'Sheikhupura', 'Mirpur Khas', 'Gujrat', 'Jhang'];
  List<String> bedrooms = ['Studio','1','2','3','4','5','6','7','8','9','10','11','12','13'];
  List<String> bathrooms = ['1','2','3','4','5','6','7'];


  //

  //Controllers
  TextEditingController plotNumberController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //

  //bool
  //

  //Form Key
  final formKey = GlobalKey<FormState>();
  //


  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
  
    final provider = Provider.of<AddPostProvider>(context,listen: true);

    Future<void> _getImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
         provider.addImages(File(pickedFile.path));
      }
    }
    return Scaffold(
      backgroundColor: white,
      body: provider.isUploading?Center(child:CircularProgressIndicator(color:primaryColor)): SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: w,
              height: h*0.3,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: WidgetAnimator(
                      atRestEffect: WidgetRestingEffects.bounce(),
                      incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                      outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
                      child:SvgPicture.asset('assets/PakistanBg.svg',width: w,height: h*0.3,fit: BoxFit.cover,color: primaryColorLightForSvg.withOpacity(0.8)
                      ),),
                  ),
                  Container(
                    width: w,
                    height: h*0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
                      color: primaryColor.withOpacity(0.2),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: h*0.05,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap:(){
                                  provider.resetAll();
                                },
                                child: textRubik('Clear All', darkTextColor, w400, size14)),
                            SizedBox(width: w*0.05,),
                          ],
                        ),
                        SizedBox(height: h*0.02,),
                        Padding(
                          padding: EdgeInsets.only(left: w*0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textRubik('Add a Post', darkTextColor, w600, size22),
                                  SizedBox(height: h*0.022,),
                                  Container(
                                    width: 200,
                                    child: textLeftRubik('Reach millions of buyers searching for properties in a few steps', lightTextColor, w400, size15),
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h*0.02,),
            Padding(padding:
            EdgeInsets.symmetric(horizontal: w*0.045),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  headingRow(CupertinoIcons.checkmark_seal,'Purpose'),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      SizedBox(width: 37+8,),
                      GestureDetector(
                        onTap: (){
                            provider.updatePurposeOptionSelected('Sell');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(color:provider.purposeOptionSelected=='Sell'? primaryColor:greyShade2,width: 1),
                              color: provider.purposeOptionSelected == 'Sell'?primaryColor.withOpacity(0.3):greyShade2
                          ),
                          child: Center(
                            child: textRubik('Sell', provider.purposeOptionSelected == 'Sell'? primaryColor:darkTextColor, w500, size16),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){

                           provider.updatePurposeOptionSelected('RentOut') ;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                          margin: EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(color: provider.purposeOptionSelected =='RentOut'? primaryColor:greyShade2,width: 1),
                              color:  provider.purposeOptionSelected  == 'RentOut'?primaryColor.withOpacity(0.3):greyShade2
                          ),
                          child: Center(
                            child: textRubik('Rent Out',  provider.purposeOptionSelected  == 'RentOut'? primaryColor:darkTextColor, w500, size16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(CupertinoIcons.building_2_fill, 'Property Type'),
                  SizedBox(height: 10,),
                  Container(

                    margin: EdgeInsets.only(left: 37+8,right: 37),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap:(){

                              provider.updatePropertyTypeOption ('Homes');

                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textRoboto('Homes', provider.propertyTypeOption == 'Homes'?primaryColor:darkTextColor, w500, size16),
                              SizedBox(height: 4,),
                              Container(
                                width: 70,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: provider.propertyTypeOption == 'Homes'? primaryColor:white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            provider.updatePropertyTypeOption ('Plots');

                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textRoboto('Plots', provider.propertyTypeOption == 'Plots'?primaryColor:darkTextColor, w500, size16),
                              SizedBox(height: 4,),
                              Container(
                                width: 70,
                                height: 2,
                                decoration: BoxDecoration(
                                    color: provider.propertyTypeOption == 'Plots'? primaryColor:white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                                ),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap:(){
                            provider.updatePropertyTypeOption ('Commercial');
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textRoboto('Commercial', provider.propertyTypeOption == 'Commercial'?primaryColor:darkTextColor, w500, size16),
                              SizedBox(height: 4,),
                              Container(
                                width: 70,
                                height: 2,
                                decoration: BoxDecoration(
                                    color: provider.propertyTypeOption == 'Commercial'? primaryColor:white,
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: w,
                    height: 1,
                    margin: EdgeInsets.only(left: 37+15,right: 37+10),
                    color: greyShade2,
                  ),
                  SizedBox(height: 15,),
                  provider.propertyTypeOption == 'Homes'?
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    alignment: WrapAlignment.start,
                    runSpacing: 7,
                    spacing: 7,
                    direction: Axis.horizontal,
                    children: List.generate(propertyTypeOptionsHomesList.length, (index){
                      return
                        GestureDetector(
                        onTap: (){
                            provider.updatePropertyTypeOptionHomesSelected( propertyTypeOptionsHomesList[index]);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70),
                                  border: Border.all(color: provider.propertyTypeOptionHomesSelected == propertyTypeOptionsHomesList[index]? primaryColor:greyShade2,width: 1),
                                  color: provider.propertyTypeOptionHomesSelected == propertyTypeOptionsHomesList[index]?primaryColor.withOpacity(0.3):greyShade2
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(propertTypeIconsHomesList[index],size: size17,color: provider.propertyTypeOptionHomesSelected == propertyTypeOptionsHomesList[index]? primaryColor:darkTextColor ,),
                                  SizedBox(width: 4,),
                                  textRubik(propertyTypeOptionsHomesList[index],  provider.propertyTypeOptionHomesSelected  == propertyTypeOptionsHomesList[index]? primaryColor:darkTextColor, w500, size16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ):
                      provider.propertyTypeOption == 'Plots'?
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        verticalDirection: VerticalDirection.down,
                        alignment: WrapAlignment.start,
                        runSpacing: 7,
                        spacing: 7,
                        direction: Axis.horizontal,
                        children: List.generate(propertyTypeOptionsPlotsList.length, (index){
                          return
                            GestureDetector(
                              onTap: (){

                                  provider.updatePropertyTypeOptionPlotsSelected(propertyTypeOptionsPlotsList[index]) ;

                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70),
                                        border: Border.all(color: provider.propertyTypeOptionPlotsSelected == propertyTypeOptionsPlotsList[index]? primaryColor:greyShade2,width: 1),
                                        color: provider.propertyTypeOptionPlotsSelected == propertyTypeOptionsPlotsList[index]?primaryColor.withOpacity(0.3):greyShade2
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(propertTypeIconsPlotsList[index],size: size17,color: provider.propertyTypeOptionPlotsSelected == propertyTypeOptionsPlotsList[index]? primaryColor:darkTextColor ,),
                                        SizedBox(width: 4,),
                                        textRubik(propertyTypeOptionsPlotsList[index],  provider.propertyTypeOptionPlotsSelected == propertyTypeOptionsPlotsList[index]? primaryColor:darkTextColor, w500, size16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                        }),
                      ):
                      provider.propertyTypeOption == 'Commercial'?
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            alignment: WrapAlignment.start,
                            runSpacing: 7,
                            spacing: 7,
                            direction: Axis.horizontal,
                            children: List.generate(propertyTypeOptionsCommercialList.length, (index){
                              return
                                GestureDetector(
                                  onTap: (){
                                      provider.updatePropertyTypeOptionCommercialSelected( propertyTypeOptionsCommercialList[index]);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(70),
                                            border: Border.all(color: provider.propertyTypeOptionCommercialSelected == propertyTypeOptionsCommercialList[index]? primaryColor:greyShade2,width: 1),
                                            color: provider.propertyTypeOptionCommercialSelected == propertyTypeOptionsCommercialList[index]?primaryColor.withOpacity(0.3):greyShade2
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Icon(propertTypeIconsCommercialList[index],size: size17,color: provider.propertyTypeOptionCommercialSelected == propertyTypeOptionsCommercialList[index]? primaryColor:darkTextColor ,),
                                            SizedBox(width: 4,),
                                            textRubik(propertyTypeOptionsCommercialList[index],  provider.propertyTypeOptionCommercialSelected == propertyTypeOptionsCommercialList[index]? primaryColor:darkTextColor, w500, size16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }),
                          )
                              :Container(),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.location_on_outlined, 'City'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(backgroundColor: white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))),context: context, builder: (context){
                          return StatefulBuilder(builder: (context,StateSetter setStat){
                            return Container(
                                width: w,
                                height: h*0.75,
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                ),
                                padding: EdgeInsets.only(left: w*0.05,right: w*0.05,top: 25),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          textRoboto('City : '+' -- ', primaryColor, w500, size18),
                                        ],
                                      ),
                                      SizedBox(height: 7,),
                                      TextFormField(
                                        style:GoogleFonts.roboto(
                                          textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                        ),
                                        onChanged:(v){
                                            provider.updateCitySearchText(v);
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Search City',
                                          hintStyle:GoogleFonts.roboto(
                                            textStyle: TextStyle(color: greyShade2, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(55),
                                              borderSide: BorderSide(color: greyShade2,width: 1)
                                          ),
                                          enabledBorder:  OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(55),
                                              borderSide: BorderSide(color: greyShade2,width: 1)
                                          ),
                                          focusedBorder:  OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(55),
                                              borderSide: BorderSide(color: primaryColor,width: 1)
                                          ),

                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      ListView.builder(shrinkWrap: true,physics: NeverScrollableScrollPhysics(),itemBuilder: (context,index){
                                        // Filter the list based on searchText
                                        List<String> filteredCities = cities
                                            .where((city) =>
                                            city.toLowerCase().contains(provider.citySearchText.toLowerCase()))
                                            .toList();
                                        if (index >= 0 && index < filteredCities.length) {
                                          return GestureDetector(
                                            onTap: (){
                                               provider.updateSelectedCity( filteredCities[index]) ;
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: w,
                                              height: 45,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  textRoboto(filteredCities[index], darkTextColor, w500, size16)
                                                ],
                                              ),
                                            ),
                                          );}
                                        else{
                                          return Container();
                                        }

                                      },itemCount:cities.length)
                                    ],
                                  ),
                                )
                            );
                          });
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textRoboto(provider.selectedCity, darkTextColor, w500, size18),
                          Icon(Icons.arrow_forward_ios_outlined,color: darkTextColor,size: size15,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  InkWell(
                      onTap: (){
                        navigateWithTransition(context, SelectLocationAddPost(),TransitionType.slideTopToBottom);
                      },
                      child: headingRow(Icons.map_outlined, provider.selectedLocation==''?'Location':
                      provider.selectedLocation.length>=28?provider.selectedLocation.substring(0,27):provider.selectedLocation)),
                  SizedBox(height: 10,),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 37+8),
                  //   child: TextFormField(
                  //     controller: locationController,
                  //       validator: (v){
                  //      return v!.length<=2?'Invalid location':null;
                  //       },
                  //       decoration: InputDecoration.collapsed(hintText: 'Ex: DHA Defence',hintStyle:GoogleFonts.roboto(
                  //         textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                  //       ),),
                  //       style:GoogleFonts.roboto(
                  //         textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                  //       )
                  //   ),
                  // ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.landslide_rounded, 'Plot Number'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: TextFormField(
                      controller: plotNumberController,
                        validator: (v){
                        return  v!.length<1?'*required':null;
                        },
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration.collapsed(hintText: 'Ex: 218',hintStyle:GoogleFonts.roboto(
                      textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                    ),),
                      style:GoogleFonts.roboto(
                        textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      )
                    ),
                  ),


                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.area_chart_outlined, 'Area'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: areaController,
                              validator: (v){
                                return    v!.length<1?'*area is required':null;
                              },
                              keyboardType: TextInputType.numberWithOptions(),

                              decoration: InputDecoration.collapsed(hintText: 'Enter Area',hintStyle:GoogleFonts.roboto(
                                textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                              ),),
                              style:GoogleFonts.roboto(
                                textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                              )
                          ),
                        ),
                        SizedBox(width: 5,),
                        // textRoboto('$areaType', darkTextColor, w400, size16),
                        // SizedBox(width: 3,),
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
                    ),
                  ),


                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.attach_money, 'Total Price'),
                  SizedBox(height: 10,),

                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child:    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller : priceController,
                            onChanged: (v){
                             provider.formatAmount(v);
                            },
                            validator: (v){
                              return  v!.length<1?'*price is required':null;
                            },
                              keyboardType: TextInputType.numberWithOptions(),

                              decoration: InputDecoration.collapsed(
                                hintText: 'Enter price',hintStyle:GoogleFonts.roboto(
                                textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                              ),),

                              style:GoogleFonts.roboto(
                                textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                              ),

                          ),
                        ),
                        SizedBox(width: 1.5,),
                        textRubik(provider.formattedAmount, darkTextColor, w500, size15),
                        SizedBox(width: 3,),
                        textRubik('PKR', darkTextColor, w500, size17)
                      ],
                    ) ,
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      headingRow(Icons.edit_note_outlined, 'Ready for Possession'),
                      Switch(
                          activeColor: primaryColor,
                          inactiveTrackColor:MaterialStateColor.resolveWith((states) => lightTextColor),
                          activeTrackColor: MaterialStateColor.resolveWith((states) => greyShade2) ,
                          thumbColor: MaterialStateColor.resolveWith((states) => primaryColor),
                          value: provider.possessionSwitchVal, onChanged: (v){
                                  provider.updatePossessionSwitchVal(v);
                      })
                    ],
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
             provider.propertyTypeOption=='Homes'?     headingRow(Icons.meeting_room_outlined, 'Bedrooms'):Container(),
                  SizedBox(height: 10,),
                  provider.propertyTypeOption=='Homes'?       Wrap(
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
                              provider.updateBedroom( bedrooms[index]);
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
                                    textRubik(bedrooms[index],  provider.bedroom == bedrooms[index]? primaryColor:darkTextColor, w500, size16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                    }),
                  ):Container(),

                  provider.propertyTypeOption=='Homes'?       SizedBox(height: 10,):Container(),
                  provider.propertyTypeOption=='Homes'?     Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ):Container(),
                  provider.propertyTypeOption=='Homes'?     SizedBox(height: 18,):Container(),
                  provider.propertyTypeOption=='Homes'?         headingRow(Icons.shower_outlined, 'Bathrooms'):Container(),
                  provider.propertyTypeOption=='Homes'?     SizedBox(height: 10,):Container(),
                  provider.propertyTypeOption=='Homes'?      Wrap(
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

                             provider.updateBathroom( bathrooms[index]) ;

                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical:   6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    border: Border.all(color: provider.bathroom == bathrooms[index]? primaryColor:greyShade2,width: 1),
                                    color:  provider.bathroom == bathrooms[index]?primaryColor.withOpacity(0.3):greyShade2
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    textRubik(bathrooms[index],   provider.bathroom == bathrooms[index]? primaryColor:darkTextColor, w500, size16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                    }),
                  ):Container(),

                  provider.propertyTypeOption=='Homes'? SizedBox(height: 10,):Container(),
                  provider.propertyTypeOption=='Homes'?   Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ):Container(),
                  SizedBox(height: 18,),
                  headingRow(Icons.title, 'Property Title'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: TextFormField(
                      controller: titleController,
                      validator: (v){
                        return v!.length<1?'*title is required':null;
                      },
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration.collapsed(
                        hintText: 'Ex: Beautiful House',hintStyle:GoogleFonts.roboto(
                        textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),),
                      style:GoogleFonts.roboto(
                        textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.description_outlined, 'Description'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: TextFormField(
                      controller: descriptionController,
                      validator: (v){
                        return v!.length<1?'Invalid description':null;
                      },
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration.collapsed(
                        hintText: 'Description of your property',hintStyle:GoogleFonts.roboto(
                        textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),),
                      style:GoogleFonts.roboto(
                        textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.photo, 'Images of your property'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: ()async{
                            try{
                              await _getImage(ImageSource.camera);
                            }
                            catch(e){
                              print(e.toString());
                            }
                          },
                          child: Container(
                            width: w*0.5,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: primaryColor,width: 1,)
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_rounded,color: primaryColor,size: 19,),
                                  SizedBox(width: 4,),
                                  textRoboto('Camera', primaryColor, w500, size17)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 6.5,),
                        InkWell(
                          onTap: ()async{
                            try{
                             await _getImage(ImageSource.gallery);
                            }
                            catch(e){
                              print(e.toString());
                            }
                          },
                          child: Container(
                            width: w*0.5,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: primaryColor
                            ),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library_outlined,color: white,size: 19,),
                                  SizedBox(width: 4,),
                                  textRoboto('Gallery', white, w500, size17)
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                    provider.images.length!=0?    SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(provider.images.length, (index) {
                              return Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    margin: EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    alignment: Alignment.center,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child:
                                        kIsWeb?
                                        Image.network(provider.images[index].path):
                                      Image.file(provider.images[index]),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap:(){
                                          provider.removeImages(index);
                                      },
                                      child: Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                            color: white.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(200),
                                            border: Border.all(color: lightTextColor,width: 1)
                                        ),
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Icon(Icons.close,color: darkTextColor,size: 15,),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              );
                            })
                          ),
                        ):Container()
                      ],
                    )
                  ),


                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.email_outlined, 'Email'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: TextFormField(
                      controller: emailController,
                      validator: (v){
                        return EmailValidator.validate(v!)?null:'Invalid email';
                      },
                      keyboardType: TextInputType.emailAddress,

                      decoration: InputDecoration.collapsed(
                        hintText: 'xyz@gmail.com',hintStyle:GoogleFonts.roboto(
                        textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),),
                      style:GoogleFonts.roboto(
                        textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 18,),
                  headingRow(Icons.phone, 'Phone Number'),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: TextFormField(
                      controller: phoneController,
                      validator: (v){
                        return   validatephone(v!);
                      },
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration.collapsed(
                        hintText: 'Enter your contact',hintStyle:GoogleFonts.roboto(
                        textStyle: TextStyle(color: lightTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),),
                      style:GoogleFonts.roboto(
                        textStyle: TextStyle(color: darkTextColor , letterSpacing: .5,fontWeight: w400,fontSize: size15),
                      ),
                    ),
                  ),


                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(left: 37+8),
                    child: Container(
                      width: w,
                      height: 1,
                      color: greyShade2,
                    ),
                  ),
                  SizedBox(height: 27,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap:()async{
                              if(provider.selectedLocation!=''){
                                if(formKey.currentState!.validate()) {
                                  try {
                                    // if (provider.images.isNotEmpty) {
                                    //   for (var image in provider.images) {
                                    //     try {
                                    //       // Create a unique file name for each image
                                    //       String fileName = DateTime
                                    //           .now()
                                    //           .millisecondsSinceEpoch
                                    //           .toString();
                                    //
                                    //       // Reference to Firebase Storage
                                    //       Reference storageRef = FirebaseStorage
                                    //           .instance.ref().child(
                                    //           'images/$fileName');
                                    //       if (kIsWeb) {
                                    //         Uint8List imageData = await XFile(
                                    //             image!.path).readAsBytes();
                                    //
                                    //         await storageRef.putData(
                                    //           imageData,
                                    //           SettableMetadata(
                                    //               contentType: 'image/jpeg'), // Specify content type for web
                                    //         );
                                    //
                                    //         final imageUrl = await storageRef
                                    //             .getDownloadURL();
                                    //         provider. addImageUrls(imageUrl);
                                    //       } else {
                                    //         var x = await storageRef.putFile(
                                    //             image!);
                                    //         String imageUrlMobile = await x
                                    //             .ref.getDownloadURL();
                                    //
                                    //        provider. addImageUrls(imageUrlMobile);
                                    //       }
                                    //     } catch (e) {
                                    //       print('Error uploading image: $e');
                                    //     }
                                    //   }
                                    //
                                    //   CollectionReference rootRef = await FirebaseFirestore
                                    //       .instance.collection(
                                    //       provider.purposeOptionSelected);
                                    //
                                    //   CollectionReference typeRef = await rootRef
                                    //       .doc().collection(
                                    //       provider.propertyTypeOption);
                                    //
                                    //   CollectionReference cityRef = await typeRef
                                    //       .doc().collection(
                                    //       provider.selectedCity);
                                    //
                                    //   await cityRef.add(
                                    //       {
                                    //         'purpose': provider
                                    //             .purposeOptionSelected,
                                    //         'propertyTypeOption': provider
                                    //             .propertyTypeOption,
                                    //         'city': provider.selectedCity,
                                    //         'homesPlotsCommercial': provider
                                    //             .propertyTypeOption == 'Homes'
                                    //             ? provider
                                    //             .propertyTypeOptionHomesSelected
                                    //             :
                                    //         provider.propertyTypeOption ==
                                    //             'Plots'
                                    //             ? provider
                                    //             .propertyTypeOptionPlotsSelected
                                    //             :
                                    //         provider.propertyTypeOption ==
                                    //             'Commercial'
                                    //             ? provider
                                    //             .propertyTypeOptionCommercialSelected
                                    //             : 'null',
                                    //         'location': locationController
                                    //             .text.toString(),
                                    //         'plotNumber': plotNumberController
                                    //             .text.toString(),
                                    //         'area': areaController.text
                                    //             .toString(),
                                    //         'areaType': provider.areaType,
                                    //         'totalPrice': priceController.text
                                    //             .toString(),
                                    //         'readyForPossession': provider
                                    //             .possessionSwitchVal
                                    //             .toString(),
                                    //         'bedrooms': provider
                                    //             .propertyTypeOption != 'Homes'
                                    //             ? 'null'
                                    //             : provider.bedroom,
                                    //         'bathrooms': provider
                                    //             .propertyTypeOption != 'Homes'
                                    //             ? 'null'
                                    //             : provider.bathroom,
                                    //         'propertyTitle': titleController
                                    //             .text.toString(),
                                    //         'propertyDescription': descriptionController
                                    //             .text.toString(),
                                    //         'images': provider.imageUrls,
                                    //         'displayImage': provider.imageUrls[0],
                                    //         'phone': phoneController.text
                                    //             .toString(),
                                    //       });
                                    // }
                                    //
                                    // else {
                                    //   CollectionReference rootRef = await FirebaseFirestore
                                    //       .instance.collection(
                                    //       provider.purposeOptionSelected);
                                    //
                                    //   CollectionReference typeRef = await rootRef
                                    //       .doc().collection(
                                    //       provider.propertyTypeOption);
                                    //
                                    //   CollectionReference cityRef = await typeRef
                                    //       .doc().collection(
                                    //       provider.selectedCity);
                                    //
                                    //   await cityRef.add(
                                    //       {
                                    //         'purpose': provider
                                    //             .purposeOptionSelected,
                                    //         'propertyTypeOption': provider
                                    //             .propertyTypeOption,
                                    //         'city': provider.selectedCity,
                                    //         'homesPlotsCommercial': provider
                                    //             .propertyTypeOption == 'Homes'
                                    //             ? provider
                                    //             .propertyTypeOptionHomesSelected
                                    //             :
                                    //         provider.propertyTypeOption ==
                                    //             'Plots'
                                    //             ? provider
                                    //             .propertyTypeOptionPlotsSelected
                                    //             :
                                    //         provider.propertyTypeOption ==
                                    //             'Commercial'
                                    //             ? provider
                                    //             .propertyTypeOptionCommercialSelected
                                    //             : 'null',
                                    //         'location': locationController
                                    //             .text.toString(),
                                    //         'plotNumber': plotNumberController
                                    //             .text.toString(),
                                    //         'area': areaController.text
                                    //             .toString(),
                                    //         'areaType': provider.areaType,
                                    //         'totalPrice': priceController.text
                                    //             .toString(),
                                    //         'readyForPossession': provider
                                    //             .possessionSwitchVal
                                    //             .toString(),
                                    //         'bedrooms': provider
                                    //             .propertyTypeOption != 'Homes'
                                    //             ? 'null'
                                    //             : provider.bedroom,
                                    //         'bathrooms': provider
                                    //             .propertyTypeOption != 'Homes'
                                    //             ? 'null'
                                    //             : provider.bathroom,
                                    //         'propertyTitle': titleController
                                    //             .text.toString(),
                                    //         'propertyDescription': descriptionController
                                    //             .text.toString(),
                                    //         'images': [],
                                    //         'displayImage': 'data:image/jpeg;base64,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',
                                    //         'phone': phoneController.text
                                    //             .toString(),
                                    //       });
                                    // }
                                    await  postAdd(
                                        provider: provider,
                                        location: provider.selectedLocation,
                                        phoneController: phoneController,
                                        emailController: emailController,
                                        descriptionController: descriptionController,
                                        titleController: titleController,
                                        plotNumberController: plotNumberController,
                                        priceController: priceController,
                                        areaController: areaController,
                                        context: context
                                    ).then((value) {

                                      phoneController.text = '';
                                      emailController.text = '';
                                      descriptionController.text = '';
                                      titleController.text = '';
                                      plotNumberController.text = '';
                                      priceController.text = '';
                                      areaController.text = '';

                                      showDialog(context: context, builder: (context){
                                        return Center(
                                          child: Container(
                                            width: 270,
                                            height: 270,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                    borderRadius: BorderRadius.circular(100),
                                                    child: Image.asset(provider.isSuccess?'assets/success.png':'assets/fail.png',width: 150,height: 150,)),
                                                SizedBox(height: 15,),
                                                textCenter(provider.isSuccess?'Add Posted Successfully!':'Failed to Post!, try again later', provider.isSuccess?green:red, w500, size18)
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    });
                                  }
                                  catch (e) {
                                    print(e.toString());
                                  }
                                }

                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Please choose a Location!', white,w400, size17)));
                              }
                          },
                        child: Container(
                          width: w*0.43,
                          height: 45,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: textRoboto('Post Ad', white, w600, size20),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            ),
            SizedBox(height: h*0.045,)
          ],
        ),
      ),
    );
  }
   validatephone(String value) {
    if (value.length != 11)
      return 'Invalid Phone';
    else
      return null;
  }

  Widget headingRow(IconData iconData,String title){
    return      Row(
      children: [
        Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: greyShade2
          ),
          alignment: Alignment.center,
          child: Center(
            child: Icon(iconData,color: greyShade3,size: 20,),
          ),
        ),
        SizedBox(width: 8,),
        textRubik(title, darkTextColor, w500, size18)
      ],
    );
  }

}
