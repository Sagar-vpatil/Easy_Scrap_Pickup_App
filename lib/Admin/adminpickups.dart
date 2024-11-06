import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'adminhome.dart';
import '../service/database.dart';

class MyAdminPickups extends StatefulWidget {
  const MyAdminPickups({super.key});

  @override
  State<MyAdminPickups> createState() => _MyAdminPickupsState();
}

class _MyAdminPickupsState extends State<MyAdminPickups> {
  String _selectedSection = 'Scheduled';
  Stream? scheduledPickupsStream;
  Stream? completedPickupsStream;
  @override
  void initState() {
    // Debugging: Print phone number to console
    getPickups();
    super.initState();
  }
  getPickups() async {
    scheduledPickupsStream = await DatabaseMethod().getAllScheduledPickups();
    setState(() {

    });

    completedPickupsStream = await DatabaseMethod().getAllCompletedPickups();
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => showDetailsDialog(ds),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text('More Details'),
                                  ),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: () => changePickupStatus(ds["OrderID"]),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text('Change Status'),
                                  ),
                                ],
                              )
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

  void showDetailsDialog(DocumentSnapshot ds) {
    String userName = ds["UserName"];
    String userPhone = ds["Phone"];
    String pickupAddress = ds["PickupAddress"];

    var screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(Icons.person, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'User Details',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: screenSize.width * 0.05),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: $userName',
                style: TextStyle(fontSize: screenSize.width * 0.04),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Phone: $userPhone',
                    style: TextStyle(fontSize: screenSize.width * 0.04),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                launch('tel:$userPhone');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: screenSize.width * 0.04),
                child: Text(
                  'Call Now',
                  style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: screenSize.width * 0.04),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  void changePickupStatus(String orderId) async {
    var screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(Icons.info, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Change Pickup Status',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: screenSize.width * 0.05),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to change the status of this pickup?',
            style: TextStyle(fontSize: screenSize.width * 0.04),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await DatabaseMethod().updatePickupStatus(orderId);
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Complete Pickup',
                style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: screenSize.width * 0.04),
              ),
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
        title: const Text('Pickups',style:
        TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        automaticallyImplyLeading: false,
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
          const BottomNavigationBarExample(selectedIndex: 2), // Ensure BottomNavigationBarExample is defined
        ],
      ),
    );
  }
}
