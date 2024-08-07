import 'dart:io';

import 'package:asaanmakaan/Constants/Color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Constants/FontSizes.dart';
import '../../../Constants/FontWeights.dart';
import '../../../Utils/Text.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


   File? profileImage;
  bool isLoading = true;

  String firstName = 'Guest';
  String lastName = '';
  String email = 'guest@gmail.com';
  String phone = '0333 1111000';
  String imageUrl = '';

  Future<void> getUserDetails ()async{
    try{
      DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      String _firstName = await userSnap['firstName'];
      String _lastName = await userSnap['lastName'];
      String _email = await userSnap['email'];
      String _phone = await userSnap['phone'];

      String _imageUrl = '';

      print(_firstName);
      try{
        _imageUrl = await userSnap['imageUrl'];
      }
      catch(e){
        print(e.toString());
      }


      setState(() {
        firstName = _firstName;
        lastName = _lastName;
        email = _email;
        imageUrl = _imageUrl;
        phone = _phone;
      });

          firstNameController.text = _firstName;
          lastNameController.text = _lastName;
          phoneController.text = _phone;
          emailController.text = _email;
      setState(() {
        isLoading = false;
      });
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }
  Future<void> init()async{

    await getUserDetails();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
    final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {



    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(

      backgroundColor: white,
      body: isLoading? Center(child:CircularProgressIndicator(color: primaryColor,)):

        SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w*0.05),
          child:
          Form(

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
                    textLeftRubik('Profile Settings', darkTextColor, w600, size25),
                  ],
                ),
                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     InkWell(
                      onTap:()async{
                        try{
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                               setState(() {
                                 profileImage = File(pickedFile.path);
                               });
                          }
                        }
                        catch(e){
                          print(e.toString());
                        }
                    },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: greyShade2,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child:
                              profileImage!=null?
                              kIsWeb?Image.network(profileImage!.path):Image.file(profileImage!,fit:BoxFit.cover):
                          imageUrl != ''?Image.network(imageUrl,fit: BoxFit.cover,):Image.asset('assets/doodles.png',fit: BoxFit.cover,),
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),

                  ],
                ),
                              SizedBox(height: 50,),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: firstNameController,
                        validator:(v){
                          return v!.length<1?'Invalid Name':null;
                        },
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: darkTextColor,
                            fontWeight: w400,
                            fontSize: size16,
                          ),
                          ),
                        decoration: InputDecoration(
                          prefixIcon:  Icon(Icons.person,color: darkTextColor,),
                            hintText: firstName,
                          label: textRubik('Full Name', darkTextColor, w500, size16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  darkTextColor,width: 1.75)
                          ),
                          errorBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.redAccent,width: 1.75)
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14,),   Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: lastNameController,
                        validator:(v){
                          return v!.length<1?'Invalid Name':null;
                        },
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: darkTextColor,
                            fontWeight: w400,
                            fontSize: size16,
                          ),
                          ),
                        decoration: InputDecoration(
                          prefixIcon:  Icon(Icons.person,color: darkTextColor,),
                            hintText: lastName,
                          label: textRubik('Last Name', darkTextColor, w500, size16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  darkTextColor,width: 1.75)
                          ),
                          errorBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.redAccent,width: 1.75)
                          ),
                        ),

                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14,),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: emailController,
                        validator:(v){
                          return EmailValidator.validate(v.toString())?null:'Invalid email';
                        },
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: darkTextColor,
                            fontWeight: w400,
                            fontSize: size16,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon:  Icon(Icons.email,color: darkTextColor,),
                        hintText: email,
                          label: textRubik('Email', darkTextColor, w500, size16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  darkTextColor,width: 1.75)
                          ),
                          errorBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.redAccent,width: 1.75)
                          ),
                        ),

                      ),
                    ),
                  ],
                ),

                SizedBox(height: 14,),
                Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: phoneController,
                        validator:(v){
                          return v!.length==11?null:'Invalid email';
                        },
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            color: darkTextColor,
                            fontWeight: w400,
                            fontSize: size16,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon:  Icon(Icons.phone,color: darkTextColor,),
                          hintText: phone,
                          label: textRubik('Phone number', darkTextColor, w500, size16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  lightTextColor,width: 1)
                          ),
                          focusedBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color:  darkTextColor,width: 1.75)
                          ),
                          errorBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.redAccent,width: 1.75)
                          ),
                        ),

                      ),
                    ),
                  ],
                ),

                SizedBox(height:40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()async{
                        if(formKey.currentState!.validate()){
                          try{
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              // Create a unique file name for each image
                              String fileName = DateTime
                                  .now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              // Reference to Firebase Storage
                              Reference storageRef = FirebaseStorage
                                  .instance.ref().child(
                                  'images/$fileName');
                              if (kIsWeb) {
                                Uint8List imageData = await XFile(
                                    profileImage!.path).readAsBytes();

                                await storageRef.putData(
                                  imageData,
                                  SettableMetadata(
                                      contentType: 'image/jpeg'), // Specify content type for web
                                );

                                final _imageUrl = await storageRef
                                    .getDownloadURL();

                                  imageUrl = _imageUrl;
                              } else {
                                var x = await storageRef.putFile(
                                    profileImage!);
                                String imageUrlMobile = await x
                                    .ref.getDownloadURL();
                                  imageUrl = imageUrlMobile;

                              }
                            }
                            catch (e) {
                              print('Error uploading image: $e');
                            }
                            await FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).update(
                                {
                                  'firstName':firstNameController.text.toString(),
                                  'lastName':lastNameController.text.toString(),
                                  'email':emailController.text.toString(),
                                  'phone':phoneController.text.toString(),
                                  'imageUrl':imageUrl
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
                          child: textRoboto('Update Profile', white, w400, size16),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
