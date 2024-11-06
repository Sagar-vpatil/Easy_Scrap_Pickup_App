import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../User/userhome.dart';

class MyAdminProfile extends StatefulWidget {
  const MyAdminProfile({super.key});

  @override
  State<MyAdminProfile> createState() => _MyAdminProfileState();
}

class _MyAdminProfileState extends State<MyAdminProfile> {
  // Mobile number without +91


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

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
          .collection('Admin')
          .doc(phoneNumber)
          .get();

      if (userDoc.exists){
        setState(() {
          _nameController.text = userDoc.get('AdminName');
          _mobileController.text = userDoc.get('AdminPhone');


        });
      }

    }
    catch (e){
      print('Error fetching user data: $e');
    }
  }

  void _showAboutUsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Us'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Online Kabadiwala, established in 2021,'
                      ' is a registered MSME (Micro, Small & Medium Enterprises) '
                      'and ISO-certified company specializing in scrap management solutions.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10), // Add some space between the texts
                RichText(
                  text: TextSpan(
                    text: 'Designed & Developed by ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sagar Patil',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // launch('https://systemconsultant.io/');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile',style:
        TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _nameController.text, // Display the name
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+91 ${_mobileController.text}', // Display with +91
                      style: TextStyle(fontSize: 18),
                    ),
                    // Email is not displayed here
                  ],
                ),
                // Edit icon has been removed
              ],
            ),
            SizedBox(height: 16),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(height: 16),
            // Removed the "Support" and "Settings" ListTiles
            ListTile(
              leading: Icon(Icons.info, color: Colors.green, size: 30),
              title: Text(
                'About Us',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text('Learn more about us'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
              onTap: _showAboutUsDialog,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.green, size: 30),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text('Log out of the app'),
              onTap: () async{
                // Implement logout functionality
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarExample(selectedIndex: 3), // Adjusted selectedIndex based on remaining options
    );
  }
}
