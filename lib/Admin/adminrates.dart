import 'package:flutter/material.dart';
import 'adminhome.dart';
class MyAdminRates extends StatefulWidget {
  const MyAdminRates({super.key});

  @override
  State<MyAdminRates> createState() => _MyAdminRatesState();
}

class _MyAdminRatesState extends State<MyAdminRates> {
  int _selectedIndex = 1; // Initialize with the index of this page in the BottomNavigationBar

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
      // Stay on the current page (RatePage)
        break;
      case 2:
      // Navigate to Schedule or any other page you want
        break;
      case 3:
      // Navigate to Pickups or any other page you want
        break;
      case 4:
      // Navigate to Profile or any other page you want
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrap Rates',style:
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
        child: ListView.builder(
          itemCount: 12, // Number of rate cards
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return rateCard('NEWSPAPER', '📰', 'Rs.12 to 14 Per Kg');
              case 1:
                return rateCard('OFFICE PAPER', '📄', 'Rs.07 to 08 Per Kg');
              case 2:
                return rateCard('BOOKS', '📚', 'Rs.08 to 10 Per Kg');
              case 3:
                return rateCard('CARDBOARD', '📦', 'Rs.07 to 10 Per Kg');
              case 4:
                return rateCard('PLASTIC', '♻️', 'Rs.10 to 12 Per Kg');
              case 5:
                return rateCard('Copper', '⛏️️', 'Rs.400 to 470 Rs per Kg');
              case 6:
                return rateCard('ALUMINIUM', '📏', 'Rs.75 to 100.Rs per Kg');
              case 7:
                return rateCard('Steel', '⛓️', 'Rs.30 to Rs.40 per Kg');
              case 8:
                return rateCard('Computer CPU', '💻', 'Rs.130 TO 200.RS per Piece');
              case 9:
                return rateCard('BRASS', '🎻', 'Rs.300 to 350.Rs per Kg');
              case 10:
                return rateCard('Battery', '🔋', 'Rs.30 to Rs.70 per Kg');
              case 11:
                return rateCard('E-waste', '🖨️', 'Rs.20 to Rs.30 per Kg');
              default:
                return Container(); // Return empty container for other indices
            }
          },
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarExample(selectedIndex: 1),
    );
  }

  Widget rateCard(String title, String emoji, String rate) {
    return Container(
      margin: EdgeInsets.only(bottom: 10), // Add margin bottom
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2), // Green border
        borderRadius: BorderRadius.circular(8),
      ),
      child: Card(
        elevation: 0, // Set elevation to 0 to hide the default card shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text on the left side
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Emoji on the right side
                  Text(
                    emoji, // Emoji
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.blue, // Change emoji color to dark blue
                    ),
                  ),
                ],
              ),
              // Paragraph
              SizedBox(height: 8),
              Text(
                rate,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
