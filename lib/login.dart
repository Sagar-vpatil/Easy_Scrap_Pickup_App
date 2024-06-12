import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  static String verify = "";



  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController countryCode = TextEditingController();
  var phone="";
  @override
  void initState() {
    // TODO: implement initState
    countryCode.text = "+91";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: const Text('NDA Online Kabadiwala'),
          centerTitle: true,
          backgroundColor: Colors.green.shade600,

        ),
        body: Container(
          margin: const EdgeInsets.only(left:25,right:25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Image.asset('assets/img1.png',
                      width: 150,
                      height: 150,),

                    const SizedBox(height: 25),



                    const Text('Phone Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),

                    const SizedBox(height: 10),

                    const Text('Enter your phone number to verify your account !',
                      style: TextStyle(
                        fontSize: 16,

                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:  Row(

                          children:[

                            const SizedBox(width: 10),

                            SizedBox(
                                width:40,
                                child: TextField(
                                  controller: countryCode,
                                  decoration: const InputDecoration(

                                    border: InputBorder.none,
                                  ),
                                )
                            ),

                            const Text("|",
                              style: TextStyle(
                                fontSize: 33,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value){
                                    phone = value;
                                  },
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Phone Number",
                                  ),
                                )
                            )
                          ]


                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async{
                        //check length of phone number
                        if(phone.length<10 || phone.length>10 || phone.isEmpty ){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid Phone Number',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )
                          );
                          return;
                        }
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: countryCode.text+phone,
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) {
                            MyLogin.verify = verificationId;
                            Navigator.pushNamed(context, 'otp');
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );

                        //Navigator.pushNamed(context, 'otp');
                      },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                        child: const Text('Send the OTP',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pushNamed(context, 'signup');
                        }, child: const Text('Sign Up',style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b)

                        ),)),

                      ],
                    )

                  ]
              )
          ),
        )
    );
  }
}
