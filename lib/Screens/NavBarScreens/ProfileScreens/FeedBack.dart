import 'package:asaanmakaan/Constants/Color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';
import '../../../Utils/Text.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController feedBackController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      body: isLoading ? Center(child: CircularProgressIndicator(color: primaryColor,),):SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: h*0.06,),
                Row(
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
                    SizedBox(width: w*0.05 ,),
                    textLeftRubik('Feedback', darkTextColor, w600, size25),
                  ],
                ),
                SizedBox(height: 20,),
                TextFormField(
                  maxLines: null,

                  controller: feedBackController,

                  validator: (v){
                    return v!.length<1?'Please enter something!':null;
                  },
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline, // Move cursor to next line
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor,width: 1)
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor,width: 1)
                    ),
                    focusedBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor,width: 1.9)
                    ),
                    errorBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: red,width: 1)
                    ),
                    hintText: 'Feedback...'
                  ),
                ),
                SizedBox(height: 15,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: ()async{
                      if(formKey.currentState!.validate()){
                        try{

                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseFirestore.instance.collection('Feedback').doc(FirebaseAuth.instance.currentUser!.uid).set(
                              {
                                'feedback':feedBackController.text.toString(),
                                'uid':FirebaseAuth.instance.currentUser!.uid
                              }).then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });

                        }
                        catch(e){
                          setState(() {
                            isLoading = false;
                          });
                          print(e.toString);
                        }
                      }
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(15)
                        ),
                        child: Center(
                          child: textRoboto('Share',white , w500, size14),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 40,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
