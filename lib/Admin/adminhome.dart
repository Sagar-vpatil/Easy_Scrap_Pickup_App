import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'adminpickups.dart';
import 'adminprofile.dart';
import 'adminrates.dart';


class MyAdminHome extends StatefulWidget {
  const MyAdminHome({super.key});

  @override
  State<MyAdminHome> createState() => _MyAdminHomeState();
}

class _MyAdminHomeState extends State<MyAdminHome> {
  int _selectedIndex = 0;

  Stream<int> getTotalUsers() {
    return FirebaseFirestore.instance.collection('Users').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getTotalPickups() {
    return FirebaseFirestore.instance.collection('Pickups').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getScheduledPickups() {
    return FirebaseFirestore.instance.collection('Pickups').where('Status', isEqualTo: 'Scheduled').snapshots().map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getCompletedPickups() {
    return FirebaseFirestore.instance.collection('Pickups').where('Status', isEqualTo: 'Completed').snapshots().map((snapshot) => snapshot.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Scrap Pickup',style:
        TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        automaticallyImplyLeading: false,
        leading: Container(
          margin: EdgeInsets.only(left: 35), // Adjust margin as needed
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14159),  // Rotating 180 degrees
            child: Icon(
              Icons.local_shipping,
              color: Colors.white,
              size: 30.0,  // Adjust size as needed
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder<int>(
                    stream: getTotalUsers(),
                    builder: (context, snapshot) {
                      return buildCard('Total Users', Icons.people, snapshot.data?.toString() ?? 'Loading...');
                    },
                  ),
                  StreamBuilder<int>(
                    stream: getTotalPickups(),
                    builder: (context, snapshot) {
                      return buildCard('Total Pickups', Icons.shopping_cart, snapshot.data?.toString() ?? 'Loading...');
                    },
                  ),
                  StreamBuilder<int>(
                    stream: getScheduledPickups(),
                    builder: (context, snapshot) {
                      return buildCard('Upcoming Orders', Icons.upcoming, snapshot.data?.toString() ?? 'Loading...');
                    },
                  ),
                  StreamBuilder<int>(
                    stream: getCompletedPickups(),
                    builder: (context, snapshot) {
                      return buildCard('Completed Orders', Icons.check_circle, snapshot.data?.toString() ?? 'Loading...');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: _selectedIndex),
    );
  }

  Widget buildCard(String title, IconData icon, String value) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: Colors.purple),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigationBarExample({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() => _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAdminHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAdminRates()), // Replace with actual Rates screen
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAdminPickups()), // Replace with actual Pickups screen
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyAdminProfile()), // Replace with actual Profile screen
        );
        break;
    }
  }

  Widget _buildIcon(IconData icon, String label, bool isSelected) {
    Color iconColor = isSelected ? Colors.green : Colors.black;
    Color labelColor = isSelected ? Colors.green : Colors.black;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.green,
            width: 2.0,
          ),
        ),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Rates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Pickups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Admin',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
