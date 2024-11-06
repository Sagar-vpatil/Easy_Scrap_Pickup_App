import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otpscreen.dart';
class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  static String verify = "";
  static String Uphone = "";
  static String phoneNumber = "";

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController countryCode = TextEditingController();
  var phone = "";
  bool isLoading = false;

  @override
  void initState() {
    countryCode.text = "+91";
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Kabadiwala'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
      ),
      body: isLoading
          ? const SplashScreen()
          : Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Login Image',
                child: Image.asset(
                  'assets/login_Img.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Phone Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your phone number to verify your account!',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                height: 55,
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Semantics(
                      label: 'Country Code',
                      child: SizedBox(
                        width: 60,
                        child: TextField(
                          controller: countryCode,
                          readOnly: true,
                          style: TextStyle(fontSize: 16),  // Increased font size for readability
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),  // Adjusted spacing for consistency
                    Expanded(
                      child: Semantics(
                        label: 'Phone Number',
                        child: TextField(
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            phone = value;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: TextStyle(fontSize: 16),  // Increased font size for readability
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.blue,
                              ),
                            ),
                            labelText: "Enter Phone Number",
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),  // Added to balance the spacing
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: Semantics(
                  button: true,
                  label: 'Send the OTP',
                  child: ElevatedButton(
                    onPressed: () async {
                      if (phone.length != 10) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Invalid Phone Number',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final userCheck = FirebaseFirestore.instance
                            .collection('Users')
                            .doc(phone)
                            .get();
                        final adminCheck = FirebaseFirestore.instance
                            .collection('Admin')
                            .doc(phone)
                            .get();

                        final results = await Future.wait([userCheck, adminCheck]);
                        final isUserExists = results[0].exists;
                        final isAdminExists = results[1].exists;

                        if (isUserExists || isAdminExists) {
                          MyLogin.phoneNumber = countryCode.text + phone;
                          MyLogin.Uphone = phone;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyOtp(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Phone Number Not Registered. Please Sign Up!',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          setState(() {
                            isLoading = false;
                          });
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error: ${e.toString()}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Send the OTP',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup');
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 18,
                        color: Color(0xff4c505b),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

