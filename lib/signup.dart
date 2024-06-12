import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nda_demo/service/database.dart';
class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
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
                    // Image.asset('assets/img1.png',
                    //   width: 150,
                    //   height: 150,),

                    const SizedBox(height: 25),



                    const Text('Create Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),),

                    const SizedBox(height: 10),

                    const Text('Create Your Account For Login!',
                      style: TextStyle(
                        fontSize: 16,

                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(

                          children:[

                            const SizedBox(width: 10),

                            Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.name,
                                  controller: name,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
                                  ),
                                )
                            )

                          ]


                      ),


                    ),

                    const SizedBox(height: 20),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(

                          children:[

                            const SizedBox(width: 10),

                            Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  controller: phone,
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


                    Container(
                      height: 70, // Increase height to accommodate multiple lines
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: TextField(
                                  keyboardType: TextInputType.streetAddress,
                                  controller: address,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Address",
                                  ),
                                  maxLines: null, // Allows the text field to expand vertically
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                    const SizedBox(height: 20),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () async{
                        String Phone = phone.text;
                       Map<String,dynamic> userInfoMap = {
                         "Name": name.text,
                         "Phone":Phone,
                         "Address": address.text,
                       };
                       await DatabaseMethod().addUserDetails(userInfoMap, Phone).then((value){
                         Fluttertoast.showToast(
                             msg: "Account Created Successfully!",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.CENTER,
                             timeInSecForIosWeb: 1,
                             backgroundColor: Colors.green.shade600,
                             textColor: Colors.white,
                             fontSize: 16.0
                         );
                         Navigator.pop(context);
                       });
                      },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                        child: const Text('Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ),

                    const SizedBox(height: 20),


                  ]
              )
          ),
        )
    );
  }
}
