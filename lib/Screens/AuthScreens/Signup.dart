import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Firebase/Authentication.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/AuthScreensProviders/SignupScreenProvider.dart';
class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final provider = Provider.of<SignupScreenProvider>(context,listen: true);
    return Scaffold(
    backgroundColor: white,
      body: provider.isLoading?Center(child: CircularProgressIndicator(color: primaryColor,),)
          :

      Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20,top: 30),
              child: InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios,color: primaryColor,size: size17,)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w,
                height: h*0.2,
                child: Center(
                  child: textRubik('Register', primaryColor, w500, size30),
                ),
              ),
              Container(
                width: w,
                height: h*0.8,
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

                            controller: firstNameController,
                            validator: (v){
                              return v!.length<=2?'Invalid field':null;
                            },
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.person,color: white,),
                              label: textRubik('First Name', white, w500, size16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: white.withOpacity(0.7),width: 1)
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
                          TextFormField(

                            controller: lastNameController,
                            validator: (v){
                              return v!.length<=2?'Invalid field':null;
                            },
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.person_2,color: white,),

                              label: textRubik('Last Name', white, w500, size16),
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
                            keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined,color: white,),

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
                          TextFormField (
                            controller: phoneController,
                            validator: (v){
                              return v!.length<11?'Incorrent contact':null;
                            },
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color:  white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefixIcon: Icon(CupertinoIcons.phone,color: white,),

                              label: textRubik('Phone Number', white, w500, size16),

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
                          TextFormField(
                            controller: passwordController,
                            validator: (v){
                              return v!.length<6?'Password is too weak':null;
                            },
                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            // keyboardType: TextInputType.visiblePassword,

                            obscureText: provider.isObsecure,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,color: white,),
                              suffixIcon: InkWell(
                                  onTap:(){
                                  provider.updateObsecure();
                                  },
                                  child: Icon(provider.isObsecure?Icons.visibility_off:Icons.visibility,color: white,)),
                              label: textRubik('Password', white, w500, size16),
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
                          TextFormField(
                            obscureText: provider.isObsecure,

                            controller: confirmPasswordController,
                            validator:(v){
                              if(v.toString()==passwordController.text.toString()){
                                return null;
                              }
                              else{
                                return 'Passwords do not match';
                              }
                            },

                            style: GoogleFonts.rubik(
                              textStyle: TextStyle(
                                color: white,
                                fontWeight: w400,
                                fontSize: size16,
                              ),
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_reset_outlined,color: white,),

                              label: textRubik('Confirm Password', white, w500, size16),
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
                          SizedBox(height: h*0.1,),

                          GestureDetector(
                            onTap:()async{
                              if(formKey.currentState!.validate()){
                                  await signUp(
                                      email: emailController.text.toString(),
                                      password: passwordController.text.toString(),
                                      context: context,
                                      firstName: firstNameController.text.toString(),
                                      lastName: lastNameController.text.toString(),
                                      phone: phoneController.text.toString());
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
                              child: textRubik('Register', primaryColor, w500, size19),
                            ),
                          )
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
}
