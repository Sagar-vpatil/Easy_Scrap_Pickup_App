import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  TextEditingController userName = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userAddress = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;
  @override
  void initState() {
    if (phoneNumber.startsWith("+91")) {
      phoneNumber = phoneNumber.substring(3);
    }
    getUserData();
    super.initState();
  }



  Future getUserData() async
  {
    try{
      print(phoneNumber);
      DocumentSnapshot userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(phoneNumber)
          .get();
      if (userDoc.exists){
        setState(() {
          userName.text = userDoc.get('Name');
          userPhone.text = userDoc.get('Phone');
          userAddress.text = userDoc.get('Address');
        });
      }
    }
    catch (e){
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
            },
          ),
        ],

      ),
      //Show User Details after authentication
      body: Container(
        margin: const EdgeInsets.only(left:25,right:25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const SizedBox(height: 25),
              const Text('Welcome to NDA Online Kabadiwala',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),),
              const SizedBox(height: 10),
               Text("Name = ${userName.text} Address= ${userAddress.text} ",
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
                child: const Center(
                  child: Text('User Details',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Logout',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30,),

              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(onPressed: () async{
                  Navigator.pushNamedAndRemoveUntil(context, 'userhome', (route) => false);
                },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                  ),
                  child: const Text('User Home',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),

              ),
            ],
          ),
        ),
      ),





    );
  }
}
