import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nda_demo/login.dart';
import 'package:pinput/pinput.dart';
class MyOtp extends StatefulWidget {
  const MyOtp({super.key});

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late PinTheme defaultPinTheme;
  late PinTheme focusedPinTheme;
  late PinTheme submittedPinTheme;

  @override
  void initState() {
    super.initState();
    defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
  }
  var code = "";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(

          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
              color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

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

                     Pinput(
                      length: 6,

                      // validator: (s) {
                      //   return s == '2222' ? null : 'Pin is incorrect';
                      // },
                      // pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onChanged: (value){
                        code = value;
                      },

                    ),


                    const SizedBox(height: 20),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async{
                        try{
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: MyLogin.verify, smsCode: code);

                          // Sign the user in (or link) with the credential
                          await auth.signInWithCredential(credential);
                          Navigator.pushNamedAndRemoveUntil(
                              context, 'home', (route) => false);
                        }
                        catch(e){
                          //Show error message on the screen
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid OTP',style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              )
                          );

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
                        child: const Text('Verify Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ),

                    Row(
                      children: [
                        TextButton(onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                        }, child: const Text('Edit Phone Number ?',
                            style: TextStyle(
                              color: Colors.black,
                            )
                        ))
                      ],
                    )



                  ]
              )
          ),
        )
    );
  }
}
