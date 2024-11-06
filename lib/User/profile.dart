import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nda_demo/service/database.dart';
import 'userhome.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  TextEditingController userName = TextEditingController();
  TextEditingController userPhone = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  String? uPhone ;

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
          uPhone = userDoc.get('Phone');
        });
      }

    }
    catch (e){
      print('Error fetching user data: $e');
    }
  }

  void _showEditDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: userName,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: userPhone,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                TextField(
                  controller: userAddress,
                  decoration: InputDecoration(labelText: 'Address'),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async{
                Map<String, dynamic> updatedInfoMap = {
                  "Name": userName.text,
                  "Phone": userPhone.text,
                  "Address": userAddress.text,
                };
                //check phone number is valid or not
                if (userPhone.text.length != 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid phone number'),
                    ),
                  );
                  return;
                }
                else if (userName.text.isEmpty || userPhone.text.isEmpty || userAddress.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all the fields'),
                    ),
                  );
                  return;
                }
                else if (userPhone.text != uPhone){
                  print(phoneNumber);
                  print(userPhone.text);
                  DocumentSnapshot checkUserPhone = await FirebaseFirestore
                      .instance
                      .collection('Users')
                      .doc(userPhone.text)
                      .get();
                  if (!checkUserPhone.exists) {
                    await DatabaseMethod().deleteUserDetails(phoneNumber);
                    await DatabaseMethod().updatePickupPhone(userPhone.text, phoneNumber);
                    await DatabaseMethod().addUserDetails(updatedInfoMap, userPhone.text).then((value)async{
                      ScaffoldMessenger.of(context).showSnackBar(

                        SnackBar(
                          content: Text('Profile updated successfully, Please Verify Your New Phone Number'),

                        ),
                      );
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                    });

                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Phone Number Already Used'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                }
                else if(userPhone.text == uPhone){
                  await DatabaseMethod().updateUserDetails(updatedInfoMap, phoneNumber).then((value){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                    Navigator.of(context).pop();
                  });
                  getUserData();
                }

                // FirebaseFirestore.instance
                //     .collection('Users')
                //     .doc(user!.phoneNumber)
                //     .update(updatedInfoMap)
                //     .then((value) {
                //   Navigator.of(context).pop();
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text('Profile updated successfully'),
                //     ),
                //   );
                // }).catchError((error) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text('Failed to update profile'),
                //     ),
                //   );
                // });

              },
            ),
          ],
        );
      },
    );
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Support'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/S1.jpeg', // Adjust path to your image
                  height: 260,
                ),
                SizedBox(height: 16),
                Text(
                  'Online Kabadiwala Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Contact: 9373042946', // Display contact number
                  style: TextStyle(fontSize: 16),
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
                  'Developed by: Sagar Patil', // Display your team name
                  style: TextStyle(fontSize: 16),
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

  void _logout() async{
    // Implement your logout functionality here
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove the leading arrow icon
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
                      '${userName.text}', // Display user name
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '+91 ${userPhone.text}',  // Display with +91
                      style: TextStyle(fontSize: 18),
                    ),
                    // Email is not displayed here
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: _showEditDialog,
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(
              color: Colors.grey,
              height: 1,
            ),
            SizedBox(height: 16),

            ListTile(
              leading: Icon(Icons.support, color: Colors.green, size: 30),
              title: Text(
                'Support',
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text('Contact support for assistance'),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
              onTap: _showSupportDialog,
            ),
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
              // Added version number
              onTap: _logout,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: 4), // Assuming this widget exists elsewhere in your project
    );
  }
}
