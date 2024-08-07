import 'package:asaanmakaan/Constants/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Constants/AreasOfPakistan.dart';
import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/AddPostProvider.dart';
import '../../Providers/SearchProvider.dart';
import '../../Utils/Text.dart';

class SelectLocationAddPost extends StatefulWidget {
  const SelectLocationAddPost({Key? key}) : super(key: key);

  @override
  State<SelectLocationAddPost> createState() => _SelectLocationAddPostState();
}

class _SelectLocationAddPostState extends State<SelectLocationAddPost> {

  TextEditingController searchLocationController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final provider = Provider.of<SearchProvider>(context);

    return Scaffold(
        backgroundColor: white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h*0.06,),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: w*0.043),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        ),
                        SizedBox(width: 4,),


                        Consumer<AddPostProvider>(
                          builder: (context,provider,_){
                            return Flexible(child:
                            TextFormField(
                              controller: searchLocationController,
                              style:GoogleFonts.roboto(
                                textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                              ),
                              onChanged:(value){
                                provider.filterLocations(value); // Update filtered locations
                                provider.selectedLocation = value; // Update selected location
                              },

                              decoration: InputDecoration(
                                errorText: provider.validateLocation(provider.selectedLocation)
                                    ? null
                                    : 'Please choose a valid location',
                                prefixIcon: Icon(CupertinoIcons.location_circle,color: primaryColor,size: size24,),
                                hintText: 'Enter location...',
                                hintStyle:GoogleFonts.roboto(
                                  textStyle: TextStyle(color: greyShade2, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: greyShade2,width: 1)
                                ),
                                enabledBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: greyShade2,width: 1)
                                ),
                                focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor,width: 1)
                                ),

                              ),
                            )
                            );
                          },
                        )

                      ],
                    ),
                  ),
                  SizedBox(height: h*0.01,),
                  Consumer<SearchProvider>(
                      builder: (context, provider, _){
                        return     Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width:w*0.05),

                            InkWell(
                                onTap:(){
                                  provider.selectedLocation='';
                                  searchLocationController.text='';
                                  Navigator.pop(context);
                                },
                                child: textRoboto('Select None?', Colors.blue, w400, size18)),
                          ],
                        );
                      }),
                  SizedBox(height: h*0.01,),

                  Container(
                      width: w,
                      height: h*0.8,
                      child:
                      Consumer<AddPostProvider>(
                          builder: (context, provider, _){
                            return      ListView.builder(itemBuilder: (context,index){
                              return
                                InkWell(
                                  onTap: () {
                                    provider.selectedLocation = provider.filteredLocations[index];
                                    searchLocationController.text = provider.filteredLocations[index];

                                  },
                                  child: Container(
                                    width: w,
                                    height: 30,
                                    padding: EdgeInsets.symmetric(horizontal: w*0.04),
                                    margin: EdgeInsets.only(top: 4),
                                    child: textRobotoMessage(provider.filteredLocations[index], darkTextColor.withOpacity(0.8),w400, size16),
                                  ),
                                );
                            },shrinkWrap: false,physics: ClampingScrollPhysics(),itemCount:  provider.filteredLocations.length,);
                          })

                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 140,
                height: 55,
                color: Colors.transparent,
                child: InkWell(
                  onTap:(){
                    if(provider.selectedLocation==''){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Please choose a Location!', white,w400, size17)));
                    }
                    else{
                      Navigator.pop(context);
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 15,right: w*0.05),
                    color: primaryColor,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: textRoboto('Select', white, w500, size18),
                    ),
                  ),
                ),
              ),

            )
          ],
        )
    );
  }
}
