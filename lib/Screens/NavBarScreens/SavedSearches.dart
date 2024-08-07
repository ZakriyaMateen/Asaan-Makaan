import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Utils/Text.dart';
import 'SearchResultsFromSavedSearches.dart';

class SavedSearches extends StatefulWidget {
  const SavedSearches({Key? key}) : super(key: key);

  @override
  State<SavedSearches> createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: greyShade3,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h*0.06,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w*0.04),
              child: Row(
                children: [
                  InkWell(
                    onTap: (){Navigator.pop(context);},
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: white,
                          shape: BoxShape.circle
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_new_outlined,color: darkTextColor,size: size12,),
                      ),
                    ),
                  ),SizedBox(width: 15,),
                  SizedBox(width: w*0.05 ,),   textLeftRubik('Saved Searches', white, w600, size25),
                ],
              ),
            ),
            SizedBox(height: 20,),

                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('SavedSearches')
                // .orderBy('timestamp', descending: true) // Sort by 'createdAt' field in descending order
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

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                    final data = docs[index].data();
                      return InkWell(
                        onTap:()async{
                          navigateWithTransition(context, SearchResultsFromSavedSearches(buyRent: data['buyRent'], selectedCity: data['city'], searchTitle: data['searchTitle'], homePlotCommercial: data['homePlotCommercial'], minRange: data['minRange']
                            , maxRange: data['maxRange'], minPrice: data['minPrice'],maxPrice: data['maxPrice'],), TransitionType.slideRightToLeft);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: w*0.05,vertical: 10),
                          padding: EdgeInsets.only(left: w*0.045,right: w*0.045,top: 15,bottom: 10),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      textRoboto(data['searchTitle'], darkTextColor, w500, size15),
                                      SizedBox(height: 2,),
                                      textRoboto(data['buyRent']+' | '+data['homePlotCommercial'], lightTextColor, w400, size17),
                                    ],
                                  ),
                                  InkWell(
                                    onTap:()async{
                                      try{
                                        showDialog(
                                            context: context, builder: (context){
                                          return Dialog(
                                            backgroundColor: white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            child: Container(
                                              width: w*0.8,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                color: white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                                    child: textRobotoMessage('Delete this saved search?',lightTextColor, w400, size15),
                                                  ),
                                                  SizedBox(height: 10,),
                                                  Divider(color: greyShade2,thickness: 1,),
                                                  SizedBox(height: 10,),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      SizedBox(),
                                                      InkWell(
                                                          onTap:(){Navigator.pop(context);},
                                                          child: textRoboto('No', darkTextColor, w500, size16)),
                                                      SizedBox(),
                                                      VerticalDivider(color: greyShade2,thickness: 1,indent: 50,),
                                                      SizedBox(),
                                                      InkWell(
                                                          onTap:()async{
                                                            try{
                                                              await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).collection('SavedSearches').doc(data['docId']).delete().then((value) {
                                                                Navigator.pop(context);
                                                              });
                                                            }
                                                            catch(e){
                                                              print(e.toString());
                                                            }
                                                          },
                                                          child: textRoboto('Yes', darkTextColor, w500, size16)),
                                                      SizedBox(),

                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                      catch(e){
                                        print(e.toString());
                                      }
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: greyShade2,
                                        shape: BoxShape.circle
                                      ),
                                      child: Center(
                                        child:Icon(Icons.delete_forever_outlined,color: red,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Divider(
                                thickness: 1,
                                color: greyShade2,
                              ),
                              SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(width: 30,height: 30,decoration: BoxDecoration(
                                    color: greyShade2,
                                    shape: BoxShape.circle
                                  ),
                                  child: Icon(Icons.location_on_outlined,color: greyShade4,),
                                  ),
                                  SizedBox(width: 5,),
                                  textRoboto(data['city'], darkTextColor, w500, size14)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                  },itemCount: docs.length,);
                  
                }})

    ],
        ),
      ),
    );  
  }
}
