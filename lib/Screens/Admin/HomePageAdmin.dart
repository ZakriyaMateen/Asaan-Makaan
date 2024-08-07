import 'package:asaanmakaan/Providers/AuthScreensProviders/LoginWeb.dart';
import 'package:asaanmakaan/Providers/HomePageAdminProvider.dart';
import 'package:asaanmakaan/Screens/AuthScreens/Login.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Constants/Color.dart';
import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import 'UserDetails.dart';


class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  State<HomePageAdmin> createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  String emailSearchText = '';
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageAdminProvider>(context,listen: false);

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: greyShade2,
      body: Stack(
        children: [

          Container(width: w,height: h,
          child: Image.asset('assets/doodles1.png',fit: BoxFit.cover,),),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: h*0.02,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textRoboto('Administration', white, w600, size22)
                ],
              ),
              SizedBox(height: h*0.001,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: w*0.035+w*0.03),
                    child:    Container(
                      width: w*0.28,
                      child: TextFormField(

                        style:GoogleFonts.roboto(
                          textStyle: TextStyle(color: primaryColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                        ),
                        onChanged:(v){
                          provider.updateSearchText(v);
                        },
                        decoration: InputDecoration(
                          fillColor: white,
                          filled: true,
                          hintText: 'Search User...',
                          hintStyle:GoogleFonts.roboto(
                            textStyle: TextStyle(color: darkTextColor, letterSpacing: .5,fontWeight: w400,fontSize: size15),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(55),
                              borderSide: BorderSide(color: darkTextColor,width: 1)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(55),
                              borderSide: BorderSide(color: darkTextColor,width: 1)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(55),
                              borderSide: BorderSide(color: primaryColor,width: 1.5)
                          ),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: h*0.012,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: w*0.03),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    //Users
                    Container(
                      width: w*0.35,
                      height: h*0.8,
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(12)
                      ),

                      padding: EdgeInsets.only(left: w*0.002,right: w*0.004,top: h*0.004),



                 child: Consumer<HomePageAdminProvider>(
                      builder: (context,provider,_){
                       return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance.collection('Users').snapshots(),

                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return  Center(
                                child: CircularProgressIndicator(color: primaryColor,),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final unFilteredDocs = snapshot.data!.docs;
                              final docs = unFilteredDocs.where((doc) {
                                var data = doc.data();
                                String email = data['email'] ?? '';
                                String firstName = data['firstName'] ?? '';
                                String lastName = data['lastName'] ?? '';
                                String fullName = firstName + lastName;
                                return email.toLowerCase().contains(provider.searchText) ||
                                    fullName.toLowerCase().contains(provider.searchText);
                              }).toList();

                              return    ListView.builder(itemBuilder: (context,index){
                                var data = docs[index].data();

                                return InkWell(
                                  onTap:(){
                                    navigateWithTransition(context, UserDetails(uid: data['uid'],),TransitionType.slideTopToBottom);
                                  },
                                  child: Container(
                                    width: w*0.35-0.004-0.004,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    margin: EdgeInsets.only(top: index==0?h*0.008*2+size26:8),

                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: 10,),
                                            InkWell(
                                              onTap:(){
                                                showDialog(context: context, builder:(context){
                                                  return Dialog(
                                                    backgroundColor: white,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(100)
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundImage: NetworkImage(data['imageUrl']),
                                                      radius: 200,

                                                    ),
                                                  );
                                                });
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white,
                                                backgroundImage: NetworkImage(data['imageUrl']),
                                              ),
                                            ),
                                            SizedBox(width: w*0.02,),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                textRoboto(data['firstName']+data['lastName'], darkTextColor, w500, size20),
                                                SizedBox(height: 1,),
                                                textRoboto(data['email'], lightTextColor, w400, size17),
                                              ],
                                            ),

                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.arrow_forward_ios_rounded,color:  darkTextColor,size: size18,),
                                            SizedBox(width: 10,),
                                          ],
                                        )

                                      ],
                                    ),

                                  ),
                                );
                              },itemCount: docs.length,);
                            }});
                      })


                    ),
                    SizedBox(width: w*0.01,),
                    //Feedback
                    Container(
                      width: w*0.285,
                      height: h*0.8,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.only(top: h*0.004),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: h*0.008,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textRobotoMessage('Feedback',darkTextColor, w500, size20)
                              ],
                            ),
                            SizedBox(height: h*0.008,),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection('Feedback').snapshots(),

                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return  Center(
                                      child: CircularProgressIndicator(color: primaryColor,),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final docs = snapshot.data!.docs;

                                    return    ListView.builder(itemBuilder: (context,index){
                                      var data = docs[index].data();

                                      return Container(
                                        width: w*0.285,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        margin: EdgeInsets.only(top: 8,right:w*0.005,left: w*0.005),
                                        padding: EdgeInsets.only(left: w*0.002,right: w*0.002,top: 5,bottom: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            textRobotoMessage(data['feedback'], darkTextColor,w400, size15),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(

                                                    child: InkWell(
                                                        onTap:()async{
                                                          try{
                                                            await FirebaseFirestore.instance.collection('Feedback').doc(data['uid']).delete();
                                                          }
                                                          catch(e){
                                                            print(e.toString());
                                                          }
                                                        },
                                                        child: Icon(Icons.close,color: primaryColor,size: size18,weight: 3,)))
                                              ],
                                            )
                                          ],
                                        ),

                                      );
                                    },itemCount: docs.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);
                                  }}),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: w*0.01,),

                    //Contact Us
                    Container(
                      width: w*0.285,
                      height: h*0.8,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      padding: EdgeInsets.only(top: h*0.004),

                  child:    SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: h*0.008,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                textRobotoMessage('Messages',darkTextColor, w500, size20)
                              ],
                            ),
                            SizedBox(height: h*0.008,),
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance.collection('ContactUs').snapshots(),

                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return  Center(
                                      child: CircularProgressIndicator(color: primaryColor,),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final docs = snapshot.data!.docs;

                                    return    ListView.builder(itemBuilder: (context,index){
                                      var data = docs[index].data();

                                      return Container(
                                        width: w*0.285,
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        margin: EdgeInsets.only(top: 8,right:w*0.005,left: w*0.005),
                                        padding: EdgeInsets.only(left: w*0.004,right: w*0.004,top: 5,bottom: 5),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                textRoboto("Name", darkTextColor, w500, size18),
                                              ],
                                            ),                                        SizedBox(height: 2,),

                                            textRobotoMessage(data['name'], darkTextColor,w400, size15),
                                            SizedBox(height: 5,),

                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                textRoboto("Phone", darkTextColor, w500, size18),
                                              ],
                                            ),                                        SizedBox(height: 2,),

                                            textRobotoMessage(data['phone'], darkTextColor,w400, size15),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                textRoboto("Message", darkTextColor, w500, size18),
                                              ],
                                            ),
                                            SizedBox(height: 2,),
                                            textRobotoMessage(data['message'], darkTextColor,w400, size15),


                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                InkWell(

                                                    child: InkWell(
                                                        onTap:()async{
                                                          try{
                                                            await FirebaseFirestore.instance.collection('Feedback').doc(data['uid']).delete();
                                                          }
                                                          catch(e){
                                                            print(e.toString());
                                                          }
                                                        },
                                                        child: Icon(Icons.delete_forever_outlined,color: primaryColor,size: size18,weight: 3,)))
                                              ],
                                            )
                                          ],
                                        ),

                                      );
                                    },itemCount: docs.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),);
                                  }}),
                          ],
                        ),
                      ),

                    )




                  ],
                ),
              )
            ],
          ),
          Align(alignment: Alignment.topRight,
            child: InkWell(
              onTap: ()async{
                try{
                  await FirebaseAuth.instance.signOut().then((value){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginWeb()),);
                  });
                }
                catch(e){
                  print(e.toString());
                }
              },
              child: Container(
                width: 200,
                height: 50,
                margin: EdgeInsets.only(right: 10,top: 10),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(12)
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textRoboto('Logout ', darkTextColor,w400, size20),
                    Icon(Icons.logout,)
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
