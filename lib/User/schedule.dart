import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:nda_demo/User/userhome.dart';
import 'package:nda_demo/service/database.dart';


class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime? _selectedDate;
  String? _selectedWeight;

  // Controllers for user input
  final TextEditingController userName = TextEditingController();
  final TextEditingController userPhone = TextEditingController();
  final TextEditingController userAddress = TextEditingController();

  // Current user
  final User? user = FirebaseAuth.instance.currentUser;
  String phoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber!;

  @override
  void initState() {
    if (phoneNumber.startsWith("+91")) {
      phoneNumber = phoneNumber.substring(3);
    }
    getUserData();
    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showWeightSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Estimated Weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWeightOption('Less than 20 kg'),
              _buildWeightOption('20-50 kg'),
              _buildWeightOption('50-100 kg'),
              _buildWeightOption('100-700 kg'),
              _buildWeightOption('More than 700 kg'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightOption(String weight) {
    return ListTile(
      title: Text(weight),
      onTap: () {
        setState(() {
          _selectedWeight = weight;
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildPickupAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        child: ExpansionTile(
          title: const Text(
            'Set Pickup Address And Mobile Number',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: userAddress,
                    decoration: const InputDecoration(labelText: 'Full Address'),
                  ),
                  TextFormField(
                    controller: userPhone,
                    decoration: const InputDecoration(labelText: 'Mobile No.'),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(phoneNumber)
          .get();
      if (userDoc.exists) {
        setState(() {
          userName.text = userDoc.get('Name');
          userPhone.text = userDoc.get('Phone');
          userAddress.text = userDoc.get('Address');
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Pickup',style:
        TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePickerCard(context),
              _buildTimeInfoCard(),
              _buildWeightPickerCard(context),
              const SizedBox(height: 16),
              _buildPickupAddressCard(),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _schedulePickup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  child: const Text('SCHEDULE PICKUP'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: 2),
    );
  }

  Widget _buildDatePickerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        child: Container(
          height: 80, // Set the desired height for the card
          child: ListTile(
            title: Text(
              _selectedDate == null
                  ? 'Select Date'
                  : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        child: Container(
          height: 80, // Set the desired height for the card
          child: const ListTile(
            title: Text('Pickup Time: 9 AM to 6 PM'),
          ),
        ),
      ),
    );
  }

  Widget _buildWeightPickerCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 4,
        child: Container(
          height: 80, // Set the desired height for the card
          child: ListTile(
            title: Text(
              _selectedWeight == null
                  ? 'Select Estimated Weight'
                  : 'Selected Weight: $_selectedWeight',
            ),
            onTap: () {
              _showWeightSelectionDialog(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _schedulePickup() async {
    if (_selectedDate == null ||
        _selectedWeight == null ||
        userName.text.isEmpty ||
        userAddress.text.isEmpty ||
        userPhone.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all the details!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (userPhone.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Phone Number!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Generate a unique order ID
    String orderID = 'O${DateFormat('ddMMyy').format(DateTime.now())}${DateFormat('kkmmss').format(DateTime.now())}';
    String pickupDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);

    // Create a map to store the pickup details
    Map<String, dynamic> pickupInfoMap = {
      "OrderID": orderID,
      "UserName": userName.text,
      "PickupDate": pickupDate,
      "PickupTime": "9 AM to 6 PM",
      "EstimatedWeight": _selectedWeight,
      "PickupAddress": userAddress.text,
      "Phone": userPhone.text,
      "Status": "Scheduled",
    };

    try {
      await DatabaseMethod().addPickupDetails(pickupInfoMap, orderID);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup Scheduled!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchedulePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scheduling pickup: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
