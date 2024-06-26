import 'package:firebase/Features/App/splash_screen/SplashScreen.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/HomePage.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/loginPage.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/signUpPage.dart';
import 'package:firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(options: FirebaseOptions(apiKey: "AIzaSyBU7ejJbl_aCI4YOJSW1MOG-7eq_uKJAB8", appId: "1:506199705329:web:cdf754ca3fc4a9f5d2cb50", messagingSenderId: "506199705329", projectId: "farmassistor"));
  //runApp(const MyApp());
  }
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FarmAssistor",
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: loginPage(),
        ),
        '/login': (context) => loginPage(),
        '/signUp': (context) => signUpPage(),
        '/home': (context) => HomePage(),
        
      },
    );
  }
}

