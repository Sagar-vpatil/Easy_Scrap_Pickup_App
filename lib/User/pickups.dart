import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/database.dart';
import 'userhome.dart'; // Ensure this is correctly defined

class PickupsPage extends StatefulWidget {
  const PickupsPage({super.key});

  @override
  _PickupsPageState createState() => _PickupsPageState();
}

class _PickupsPageState extends State<PickupsPage> {
  String _selectedSection = 'Scheduled'; // Default to Scheduled section

  String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;

  Stream? scheduledPickupsStream;
  Stream? completedPickupsStream;
  @override
  void initState() {
    if (phoneNumber.startsWith("+91")) {
      phoneNumber = phoneNumber.substring(3);
    }
    print(phoneNumber); // Debugging: Print phone number to console
    getPickups();
    super.initState();
  }

  getPickups() async {
    scheduledPickupsStream = await DatabaseMethod().getScheduledPickups(phoneNumber);
    setState(() {

    });

    completedPickupsStream = await DatabaseMethod().getCompletedPickups(phoneNumber);
    setState(() {

    });
  }

  void _setSelectedSection(String section) {
    setState(() {
      _selectedSection = section;
    });
  }



  Widget allCompletedPickups() {
    return StreamBuilder(
        stream: completedPickupsStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              shrinkWrap: true, // Added to ensure the list is properly sized within its constraints
              physics: NeverScrollableScrollPhysics(), // Added to prevent nested scroll issue
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  child: Column(
                    children: [
                      Card(
                        margin: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Pickup ID:" + ds["OrderID"],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Pickup Address:" + ds["PickupAddress"],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Pickup Date: ${ds["PickupDate"]}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Pickup Time: ${ds["PickupTime"]}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('Pickup Completed'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
  Widget allScheduledPickups() {
    return StreamBuilder(
        stream: scheduledPickupsStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              shrinkWrap: true, // Added to ensure the list is properly sized within its constraints
              physics: NeverScrollableScrollPhysics(), // Added to prevent nested scroll issue
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return Container(
                  child: Column(
                    children: [
                      Card(
                        margin: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Pickup ID:" + ds["OrderID"],
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Pickup Address:" + ds["PickupAddress"],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Pickup Date: ${ds["PickupDate"]}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Pickup Time: ${ds["PickupTime"]}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _cancelPickup(ds["OrderID"]),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red, // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('Cancel Pickup'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _cancelPickup(String Id) async {
    // Handle cancel pickup action here
    // Example: Show a confirmation dialog or call an API to cancel the pickup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Pickup'),
          content: Text('Are you sure you want to cancel this pickup?'),
          actions: [
            TextButton(
              onPressed: () async{
                // Perform cancel action
                Navigator.of(context).pop();
                await DatabaseMethod().deletePickup(Id);
                 // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
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
        title: const Text(
          'Pickups',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.green[700], // Set background color to green
        centerTitle: true, // Align the title to the center
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height, // Set a bounded height
              child: ListView(
                children: [
                  // Title Row for Scheduled and Completed
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children to the start and end
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setSelectedSection('Scheduled'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Align "Scheduled" to the right side
                              children: [
                                Text(
                                  'Scheduled',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: _selectedSection == 'Scheduled'
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 100), // Add a gap between "Scheduled" and "Completed"
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _setSelectedSection('Completed'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align "Completed" to the left side
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    decoration: _selectedSection == 'Completed'
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5), // Add space between sections

                  // Display Card with message based on selected section
                  if(_selectedSection == 'Scheduled') allScheduledPickups(),
                  if(_selectedSection == 'Completed') allCompletedPickups(),

                ],
              ),
            ),
          ),
          // SizedBox(
          //   height: 350, // Specify the desired height for the image
          //   child: Image.asset(
          //     'assets/i.png', // Path to your image asset
          //     width: MediaQuery.of(context).size.width, // Set width to match screen width
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Bottom Navigation Bar
          BottomNavigationBarExample(selectedIndex: 3), // Ensure BottomNavigationBarExample is defined
        ],
      ),
    );
  }
}

