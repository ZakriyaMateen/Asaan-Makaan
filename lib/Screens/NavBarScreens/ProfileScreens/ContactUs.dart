import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Constants/Color.dart';
import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';
import '../../../Utils/Text.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: greyShade2,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*0.065),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h*0.04,),
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
                  textLeftRubik('Contact Us', darkTextColor, w600, size25),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textRoboto('Share Anything!', darkTextColor,w500, size20),
                ],
              ),
              SizedBox(height: 10,),
              textRobotoMessage('Type anything you would like to share in the message box, your queries, complains and everything!', lightTextColor, w400, size15),
              SizedBox(height: 30,),

              Container(
                width: w,
                padding: EdgeInsets.only(bottom: 20,left: 10,right: 10,top: 20),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: isLoading?Center(child:CircularProgressIndicator(color: primaryColor,)):
                Form(
                  key:formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textRoboto('Name', darkTextColor, w400, size14),
                      SizedBox(height: 7,),
                      TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 1.9)),
                          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: red,width: 1.5))
                        ),
                        controller: nameController,
                        validator: (v){
                          return v!.length<2?'Invalid Name':null;
                        },
                      ),
                      SizedBox(height: 10,),
                      textRoboto('Email', darkTextColor, w400, size14),
                      SizedBox(height: 7,),
                      TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 1.9)),
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: red,width: 1.5))
                        ),                        controller: emailController,
                        validator: (v){
                          return !EmailValidator.validate(v.toString())?'Invalid Email':null;
                        },
                      ),
                      SizedBox(height: 10,),
                      textRoboto('Phone Number', darkTextColor, w400, size14),
                      SizedBox(height: 7,),
                      TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 1.9)),
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: red,width: 1.5))
                        ),                        controller: phoneController,
                        validator: (v){
                          return v!.length!=11?'Invalid Phone Number':null;
                        },
                      ),
                      SizedBox(height: 10,),
                      textRoboto('Message', darkTextColor, w400, size14),
                      SizedBox(height: 7,),
                      TextFormField(
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: lightTextColor,width: 1)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 1.9)),
                            errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: red,width: 1.5))
                        ),                        controller: messageController,
                        validator: (v){
                          return v!.length<1?'Please enter a message':null;
                        },
                      ),
                      SizedBox(height: 20,),

                      InkWell(
                        onTap: ()async{
                        if(formKey.currentState!.validate()){
                          try{
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseFirestore.instance.collection('ContactUs').doc(FirebaseAuth.instance.currentUser!.uid).set(
                                {
                                  'name':nameController.text.toString(),
                                  'message':messageController.text.toString(),
                                  'phone':phoneController.text.toString(),
                                  'email':emailController.text.toString(),
                                  'uid':FirebaseAuth.instance.currentUser!.uid
                                }).then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                          catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: textRoboto('Could not share your message!, please try again.', white, w400, size12)));
                            setState(() {
                              isLoading = false;
                            });
                            print(e.toString());
                          }
                        }
                        },
                        child: Container(
                          width: w*0.8,
                          height: 45,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Center(
                            child: textRoboto('Send', white, w500, size17),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
