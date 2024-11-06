import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nda_demo/home.dart';
import 'package:nda_demo/login.dart';
import 'package:nda_demo/otpscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nda_demo/signup.dart';
import 'package:upgrader/upgrader.dart';
import 'Admin/adminhome.dart';
import 'Admin/adminpickups.dart';
import 'Admin/adminprofile.dart';
import 'Admin/adminrates.dart';
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        'login': (context) => const MyLogin(),
        'otp': (context) => const MyOtp(),
        'signup': (context) => const MySignUp(),
        'pickups': (context) => const PickupsPage(),
        'profile': (context) => ProfilePage(),
        'ratespage': (context) => RatesPage(),
        'schedule': (context) => const SchedulePage(),
        'userhome': (context) => const MyUserHome(),
        'adminhome': (context) => const MyAdminHome(),
        'adminrates': (context) => const MyAdminRates(),
        'adminpickups': (context) => const MyAdminPickups(),
        'adminprofile': (context) => const MyAdminProfile(),
      },
      home: UpgradeAlert(child:const AuthWrapper()),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.phoneNumber != null) {
      phoneNumber = user.phoneNumber!;
      if (phoneNumber.startsWith("+91")) {
        phoneNumber = phoneNumber.substring(3);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('Admin').doc(phoneNumber).get(),
            builder: (context, adminSnapshot) {
              if (adminSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen();
              } else if (adminSnapshot.hasData && adminSnapshot.data!.exists) {
                return UpgradeAlert(child: const MyAdminHome());
              } else {
                return UpgradeAlert(child: const MyUserHome());
              }
            },
          );
        } else {
          return UpgradeAlert(child: const MyLogin());
        }
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
