import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Screens/AuthScreens/Signup.dart';
import 'package:asaanmakaan/Screens/CustomNavBar.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMeVal = false;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String message = '';
  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: white,
      body: isLoading? Center(child: CircularProgressIndicator(color: primaryColor,),): Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,

          child:
            Padding(
              padding: EdgeInsets.only(left: w*0.05,top: h*0.06),
              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios,color: primaryColor,size: 20,)),
            )
            ,),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: h*0.6,
                child: Center(
                  child: textRubik('Forgot Password?', primaryColor, w500, size30),
                ),
              ),
              Container(
                width: w,
                height: h*0.4,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: w*0.05),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          SizedBox(height: h*0.03,),
                          textRubik('Enter the following details', white.withOpacity(0.7), w400, size12),
                          SizedBox(height: h*0.03,),


                          TextFormField(
                            controller: emailController,
                            validator:(v){
                              return EmailValidator.validate(v.toString())?null:'Invalid email';
                            },
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            onFieldSubmitted: (v){
                              if(formKey.currentState!.validate()){
                                resetEmail();
                              }
                            },
                            decoration: InputDecoration(
                              label: textRubik('Email', white, w500, size16),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color:  white.withOpacity(0.7),width: 1)
                              ),
                              enabledBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color:  white.withOpacity(0.7),width: 1)
                              ),
                              focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color:  white,width: 1.75)
                              ),
                              errorBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.redAccent,width: 1.75)
                              ),
                            ),

                          ),
                          SizedBox(height: 8,),

                          GestureDetector(
                            onTap: (){
                             Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Signup()));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                textRubik('Register new user?', white.withOpacity(0.8), w400, size12),
                                SizedBox(width: 3,),
                                Icon(Icons.arrow_forward,color: white.withOpacity(0.8),size: 15,),
                              ],
                            ),
                          ),
                            SizedBox(height: 6,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textRoboto('$message', white, w400, size13)
                            ],
                          ),

                          SizedBox(height: h*0.1,),

                          GestureDetector(
                            onTap:(){
                              if(formKey.currentState!.validate()){
                                resetEmail();
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CustomNavBar()));
                              }
                            },
                            child: Container(
                              width: w*0.7,
                              height: 50,
                              decoration: BoxDecoration(

                                color: white,
                                borderRadius: BorderRadius.circular(80),
                              ),
                              alignment: Alignment.center,
                              child: textRubik('Send Email', primaryColor, w500, size19),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
  void resetEmail()async{
    if(formKey.currentState!.validate()){
      try{
        setState(() {
          isLoading = true;
        });
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
          setState(() {
            message = 'Please check your email to reset your password!';
            isLoading = false;
          });
        });


      }
      catch(e){
        print(e.toString());
        setState(() {
          message = e.toString();
          isLoading = false;
        });
      }

    }
  }

}
