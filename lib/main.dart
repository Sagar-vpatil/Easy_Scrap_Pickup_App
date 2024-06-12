import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nda_demo/home.dart';
import 'package:nda_demo/login.dart';
import 'package:nda_demo/otpscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nda_demo/signup.dart';
import 'User/pickups.dart';
import 'User/profile.dart';
import 'User/ratespage.dart';
import 'User/schedule.dart';
import 'User/userhome.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        'login': (context) => const MyLogin(),
        'otp': (context) => const MyOtp(),
        'home': (context) => const MyHome(),
        'signup': (context) => const MySignUp(),
        'pickups': (context) => const PickupsPage(),
        'profile': (context) => ProfilePage(),
        'ratespage': (context) => RatesPage(),
        'schedule': (context) => SchedulePage(),
        'userhome': (context) => const MyUserHome(),
      },
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const MyUserHome();
        } else {
          return const MyLogin();
        }
      },
    );
  }
}
//This is Branch dev
