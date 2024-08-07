import 'package:asaanmakaan/Constants/Color.dart';
import 'package:asaanmakaan/Firebase/Authentication.dart';
import 'package:asaanmakaan/Screens/AuthScreens/Signup.dart';
import 'package:asaanmakaan/Screens/CustomNavBar.dart';
import 'package:asaanmakaan/Utils/Text.dart';
import 'package:asaanmakaan/Utils/Transitions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constants/FontSizes.dart';
import '../../Constants/FontWeights.dart';
import '../../Providers/AuthScreensProviders/LoginScreenProvider.dart';
import '../../Screens/AuthScreens/ForgotPassword.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({Key? key}) : super(key: key);

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberMeVal = false;

  Future<void> saveData(String email, String password, String rememberMe) async {
    try {
      var remember_me_Box = await Hive.openBox('remember_me');
      // var remember_me_Box = Hive.box('remember_me');
      await remember_me_Box.put('email', email);
      await remember_me_Box.put('password', password);
      await remember_me_Box.put('rememberMe', rememberMe).then((value) {
        print('remembered you!');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveDataMobile(String email, String password, String rememberMe) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('rememberMe', rememberMe);
      await pref.setString('email', email);
      await pref.setString('password',password);

    } catch (e) {
      print(e.toString());
    }
  }
  void getData() async {
    try {
      var box = await Hive.openBox('remember_me');
      String rememberMe = await box.get('rememberMe');

      if (rememberMe == 'yes') {
        print('yes we remember!');
        String email = await box.get('email');
        String password = await box.get('password');
        setState(() {
          emailController.text = email;
          passwordController.text = password;
          rememberMeVal = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void getDataMobile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = await prefs.getString('email');
      String? password = await prefs.getString('password');
      String? rememberMe = await prefs.getString('rememberMe');

      if (rememberMe == 'yes') {
        print('yes we remember!');

        setState(() {
          emailController.text = email!;
          passwordController.text = password!;
          rememberMeVal = true;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> init()async{
    if(kIsWeb){
      getData();
    }
    else{
      getDataMobile();
    }
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
    final provider = Provider.of<LoginScreenProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: white,
      body: provider.isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      )
          : Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: w*0.3,
                    height: h * 0.4,
                    child: Center(
                      child: textRubik(
                          'Welcome Back!', primaryColor, w500, size30),
                    ),
                  ),
                  Container(
                    width: w*0.3,
                    height: h * 0.6,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: h * 0.03,
                              ),
                              textRubik('Enter the following details',
                                  white.withOpacity(0.7), w400, size12),
                              SizedBox(
                                height: h * 0.03,
                              ),
                              TextFormField(
                                controller: emailController,
                                validator: (v) {
                                  return EmailValidator.validate(v.toString())
                                      ? null
                                      : 'Invalid email';
                                },
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    color: white,
                                    fontWeight: w400,
                                    fontSize: size16,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: white,
                                  ),
                                  label:
                                  textRubik('Email', white, w500, size16),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white.withOpacity(0.7),
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white.withOpacity(0.7),
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white, width: 1.75)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.75)),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                onFieldSubmitted: (v)async{
                                  if (formKey.currentState!.validate()) {
                                    if(kIsWeb){
                                      if (rememberMeVal) {
                                        saveData(emailController.text.toString(), passwordController.text.toString(), 'yes')
                                            .then((value) {
                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);
                                        });
                                      } else {
                                        saveData(emailController.text.toString(), passwordController.text.toString(),     'no')
                                            .then((value) {
                                          login(email: emailController.text.toString(),
                                              password: passwordController.text
                                                  .toString(),
                                              context: context);
                                        });
                                      }
                                    }
                                    else{
                                      if (rememberMeVal) {
                                        saveDataMobile(emailController.text.toString(), passwordController.text.toString(), 'yes')
                                            .then((value) {
                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);
                                        });
                                      } else {
                                        saveDataMobile(emailController.text.toString(), passwordController.text.toString(),     'no')
                                            .then((value) {
                                          login(email: emailController.text.toString(),
                                              password: passwordController.text
                                                  .toString(),
                                              context: context);
                                        });
                                      }
                                    }
                                  }

                                },
                                obscureText: provider.isObsecure,
                                controller: passwordController,
                                validator: (v) {
                                  return v!.length < 6
                                      ? 'Password is too weak'
                                      : null;
                                },
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    color: white,
                                    fontWeight: w400,
                                    fontSize: size16,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: white,
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: () {provider.updateObsecure();},
                                      child: Icon(provider.isObsecure ? Icons.visibility_off : Icons.visibility, color: white,)),
                                  label: textRubik(
                                      'Password', white, w500, size16),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white.withOpacity(0.7),
                                          width: 1)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white.withOpacity(0.7),
                                          width: 1)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: white, width: 1.75)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.75)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  textRubik(
                                      'Remember me?', white, w500, size13),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Checkbox(
                                    value: rememberMeVal,
                                    onChanged: (v) {
                                      setState(() {
                                        rememberMeVal = v!;
                                      });
                                    },
                                    checkColor: white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(4),
                                        side: BorderSide(color: white)),
                                    activeColor: primaryColor,
                                    side: BorderSide(color: white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),

                              SizedBox(
                                height: h * 0.085,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if(kIsWeb){
                                      if (rememberMeVal) {
                                        saveData(emailController.text.toString(), passwordController.text.toString(), 'yes')
                                            .then((value) {


                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);

                                        });
                                      } else {
                                        saveData(emailController.text.toString(), passwordController.text.toString(),     'no')
                                            .then((value) {

                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);

                                        });
                                      }
                                    }
                                    else{
                                      if (rememberMeVal) {
                                        saveDataMobile(emailController.text.toString(), passwordController.text.toString(), 'yes')
                                            .then((value) {

                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);

                                        });
                                      } else {
                                        saveDataMobile(emailController.text.toString(), passwordController.text.toString(),     'no')
                                            .then((value) {
                                          login(email: emailController.text.toString(), password: passwordController.text.toString(), context: context);

                                        });
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: w * 0.7,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                  alignment: Alignment.center,
                                  child: textRubik(
                                      'Login', primaryColor, w500, size19),
                                ),
                              ),
                              SizedBox(height: 4,),

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
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: 14,top: 5),
          //     child: GestureDetector(
          //         onTap: () {
          //           navigateWithTransition(context, ForgotPassword(),
          //               TransitionType.slideTopToBottom);
          //         },
          //         child: textCenter('Forgot Password',
          //             white.withOpacity(0.8), w400, size12)),
          //   ),
          // )
        ],
      ),
    );
  }
}
