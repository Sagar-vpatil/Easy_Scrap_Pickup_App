import 'package:flutter/material.dart';
import 'package:nda_demo/User/userhome.dart';
import 'package:nda_demo/User/userhome.dart';

class RatesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Check Rates',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30, // Set the font size for the app bar title
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, // Remove the back arrow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 18, // Display ten cards
          itemBuilder: (context, index) {
            if (index == 0) {
              // Card for NEWSPAPER
              return rateCard('NEWSPAPER', '📰', 'Rs.12 to 14 Per Kg');
            } else if (index == 1) {
              // Card for OFFICE PAPER
              return rateCard('OFFICE PAPER', '📄', 'Rs.07 to 08 Per Kg');
            } else if (index == 2) {
              // Card for BOOKS
              return rateCard('BOOKS', '📚', 'Rs.08 to 10 Per Kg');
            } else if (index == 3) {
              // Card for CARDBOARD
              return rateCard('CARDBOARD', '📦', 'Rs.07 to 10 Per Kg');
            } else if (index == 4) {
              // Card for PLASTIC
              return rateCard('PLASTIC', '♻️', 'Rs.10 to 12 Per Kg');
            } else if (index == 5) {
              // Card for IRON
              return rateCard('IRON', '🪛', 'Rs.25 to 30 Per Kg');
            } else if (index == 6) {
              // Card for GLASS
              return rateCard('Copper', '⛏️️', 'Rs.400 to 470 Rs per Kg');
            } else if (index == 7) {
              // Card for METAL
              return rateCard('ALUMINIUM', '📏', 'Rs.75 to 100.Rs per Kg');
            } else if (index == 8) {
              // Card for ELECTRONICS
              return rateCard('Steel', '⛓️', 'Rs.30 to Rs.40 per Kg');
            } else if (index == 9) {
              // Card for ELECTRONICS
              return rateCard('Computer CPU', '💻', 'Rs.130 TO 200.RS per Piece');
            } else if (index == 10) {
              // Card for ELECTRONICS
              return rateCard('BRASS', '🎻', 'Rs.300 to 350.Rs per Kg');
            } else if (index == 11) {
              // Card for ELECTRONICS
              return rateCard('Battery', '🔋', 'Rs.30 to Rs.70 per Kg');
            } else if (index == 12) {
              // Card for ELECTRONICS
              return rateCard('E-waste', '🖨️', 'Rs.20 to Rs.30 per Kg');
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: 1),
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
              SizedBox(height: 0),
              Container(
                margin: EdgeInsets.only(bottom: 5), // Add margin bottom
                child: Text(
                  rate,
                  style: TextStyle(
                    fontSize: 14,
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
