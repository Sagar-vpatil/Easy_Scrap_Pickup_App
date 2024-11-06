import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nda_demo/User/pickups.dart';
import 'package:nda_demo/User/profile.dart';
import 'package:nda_demo/User/ratespage.dart';
import 'package:nda_demo/User/schedule.dart';
class MyUserHome extends StatefulWidget {
  const MyUserHome({super.key});

  @override
  State<MyUserHome> createState() => _MyUserHomeState();
}

class _MyUserHomeState extends State<MyUserHome> {
  @override
  void initState() {
    // TODO: implement initState
    title: 'Green Themed App';
    theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[700],
        title: const Text(
          'Online Kabadiwala',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications pressed")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16.0),
              height: 200,
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions(
                  height:150,

                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 0.8,
                  aspectRatio: 16 / 9,
                  initialPage: 0,
                ),
                items: [
                  'assets/b.png',
                  'assets/b1.png',
                  'assets/home_banner3.png',
                ].map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'We are currently operational in Jalgaon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/Schedule-bro.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SchedulePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('SCHEDULE A PICKUP'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarExample(selectedIndex: 0),
    );
  }
}
class BottomNavigationBarExample extends StatefulWidget {
  final int selectedIndex;

  const BottomNavigationBarExample({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
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
          MaterialPageRoute(builder: (context) => const MyUserHome()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RatesPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SchedulePage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PickupsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  Widget _buildIcon(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20,
          child: ColorFiltered(
            colorFilter: isSelected
                ? ColorFilter.mode(Colors.green, BlendMode.srcIn)
                : ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            child: Icon(icon),
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.green : Colors.grey,
            fontSize: 15,
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 'Home', _selectedIndex == 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.monetization_on, 'Rates', _selectedIndex == 1),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.calendar_today, 'Schedule', _selectedIndex == 2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.local_shipping, 'Pickups', _selectedIndex == 3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, 'Profile', _selectedIndex == 4),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
