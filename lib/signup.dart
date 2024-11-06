import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nda_demo/service/database.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Kabadiwala'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create Your Account For Login!',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Semantics(
                label: 'Name Field',
                child: TextField(
                  keyboardType: TextInputType.name,
                  controller: name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
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
                    labelText: "Name",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: 'Phone Number Field',
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
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
                    labelText: "Phone Number",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  // Accept only digits
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: 'Address Field',
                child: TextField(
                  keyboardType: TextInputType.streetAddress,
                  controller: address,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
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
                    labelText: "Address",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                  maxLines: null, // Allows the text field to expand vertically
                ),
              ),
              const SizedBox(height: 20),
              Semantics(
                label: 'Create Account Button',
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {


                      // Check if all fields are filled
                      if (name.text.isEmpty || phone.text.isEmpty || address.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Please fill all the fields!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red.shade600,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      // Check if phone number is valid
                      else if (phone.text.length != 10) {
                        Fluttertoast.showToast(
                          msg: "Please enter a valid phone number!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red.shade600,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return;
                      }
                      else{
                        // Check if user already exists
                        DocumentSnapshot checkUserPhone = await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(phone.text)
                            .get();

                        // Check if admin already exists
                        DocumentSnapshot checkAdminPhone = await FirebaseFirestore.instance
                            .collection('Admin')
                            .doc(phone.text)
                            .get();

                        Map<String, dynamic> userInfoMap = {
                          "Name": name.text,
                          "Phone": phone.text,
                          "Address": address.text,
                        };
                        // Check if user or admin already exists
                        if (checkUserPhone.exists || checkAdminPhone.exists) {
                          Fluttertoast.showToast(
                            msg: "Account already exists with this phone number!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red.shade600,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }
                        // Create the account
                        else{
                          Fluttertoast.showToast(
                            msg: "Creating Account...",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green.shade600,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          await DatabaseMethod().addUserDetails(userInfoMap, phone.text).then((value) {
                            Fluttertoast.showToast(
                              msg: "Account Created Successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green.shade600,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.pop(context);
                          });
                        }

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
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

