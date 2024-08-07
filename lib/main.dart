import 'package:asaanmakaan/Providers/AddPostProvider.dart';
import 'package:asaanmakaan/Providers/AuthScreensProviders/LoginScreenProvider.dart';
import 'package:asaanmakaan/Providers/AuthScreensProviders/SignupScreenProvider.dart';
import 'package:asaanmakaan/Providers/HomePageAdminProvider.dart';
import 'package:asaanmakaan/Providers/HomePageSearchProvider.dart';
import 'package:asaanmakaan/Providers/SearchProvider.dart';
import 'package:asaanmakaan/Screens/NavBarScreens/SelectLocationSearch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'Providers/SearchResultsProvider.dart';
import 'Screens/Admin/HomePageAdmin.dart';
import 'Screens/AuthScreens/Login.dart';
import 'SplashScreen/AnimatedSplashScreen.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values,);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark
  ),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [
      ChangeNotifierProvider<SignupScreenProvider>( create: (context) => SignupScreenProvider()),
      ChangeNotifierProvider<LoginScreenProvider>( create: (context) => LoginScreenProvider()),
      ChangeNotifierProvider<AddPostProvider>( create: (context) => AddPostProvider()),
      ChangeNotifierProvider<SearchProvider>( create: (context) => SearchProvider()),
      ChangeNotifierProvider<SearchResultsProvider>( create: (context) => SearchResultsProvider()),
      ChangeNotifierProvider<HomePageAdminProvider>( create: (context) => HomePageAdminProvider()),
      ChangeNotifierProvider<HomePageSearchProvider>( create: (context) => HomePageSearchProvider()),
    ],
    child:  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asaan Makaan',
      home: AnimateSplashScreenMobile(),
      ),
    );
  }
}