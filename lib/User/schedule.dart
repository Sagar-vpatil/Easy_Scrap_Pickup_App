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
  TimeOfDay? _selectedTime;
  String? _selectedWeight;
  IconData? _selectedIcon;

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        print(_selectedTime!.format(context));
      });
    }
  }

  void _showWeightSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Estimated Weight'),
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
          title: Text(
            'Set Pickup Address And Mobile Number',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.arrow_drop_down),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: userAddress,
                    decoration: InputDecoration(labelText: 'Full Address'),

                  ),
                  TextFormField(
                    controller: userPhone,
                    decoration: InputDecoration(labelText: 'Mobile No.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        automaticallyImplyLeading: false, // Remove the back arrow
        title: Center(
          child: Text(
            'Schedule', // Replace with the appropriate title
            style: TextStyle(
              color: Colors.white,
              fontSize: 30, // Set the font size for the app bar title
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                      trailing: Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 4,
                  child: Container(
                    height: 80, // Set the desired height for the card
                    child: ListTile(
                      title: Text(
                        _selectedTime == null
                            ? 'Select Time'
                            : 'Selected Time: ${_selectedTime!.format(context)}',
                      ),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ),
              ),
              Padding(
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
              ),
              SizedBox(height: 16),
              _buildPickupAddressCard(),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    //String time = DateFormat('kkmmss').format(DateTime.now());
                    //String date = DateFormat('ddMMyy').format(DateTime.now());
                    // print(time);
                    // print(date);
                    String orderID = 'O${DateFormat('ddMMyy').format(DateTime.now())}${DateFormat('kkmmss').format(DateTime.now())}';
                    print(orderID);
                    String pickupDate = DateFormat('dd-MM-yyyy').format(_selectedDate!);
                    print(pickupDate);
                    print(_selectedTime!.format(context));
                    print(_selectedWeight);
                    Map<String, dynamic> pickupInfoMap = {
                      "OrderID": orderID,
                      "UserName": userName.text,
                      "PickupDate": pickupDate,
                      "PickupTime": _selectedTime!.format(context),
                      "EstimatedWeight": _selectedWeight,
                      "PickupAddress": userAddress.text,
                      "Phone": userPhone.text,
                      "Status": "Scheduled",
                    };
                    await DatabaseMethod().addPickupDetails(pickupInfoMap, orderID).then((value) {
                      // Show a snackbar to indicate that the pickup has been scheduled with green background
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pickup Scheduled!') ,backgroundColor: Colors.green,));

                    });
                    // Add your scheduling logic here
                    //final snackBar = SnackBar(content: Text('Pickup Scheduled!'));
                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //print('Scheduled pickup on ${_selectedDate} at ${_selectedTime!.format(context)}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  child: Text('SCHEDULE PICKUP'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: 2),
    );
  }
}
