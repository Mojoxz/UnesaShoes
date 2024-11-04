import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:sepatu_client/controller/register_ctrl.dart';
import 'package:sepatu_client/pages/home_page.dart';
import 'package:sepatu_client/pages/profile_tab.dart';
import 'package:sepatu_client/pages/cart_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    CartTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Mengatur status bar agar transparan
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Membuat status bar transparan
        statusBarIconBrightness: Brightness.dark, // Mengatur ikon status bar agar gelap
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Warna putih untuk background AppBar
        elevation: 0, // Menghilangkan bayangan AppBar agar lebih rata
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Image.asset(
            'assets/images/Shoe.jpg',
            height: 100,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.find<RegisterCtrl>().logout();
            },
            icon: const Icon(Icons.logout, color: Colors.black), // Warna ikon logout
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 55.0, // Height of the navigation bar
        items: const <Widget>[
          Icon(Icons.home, size: 28, color: Colors.white), // Home icon
          Icon(Icons.shopping_cart, size: 28, color: Colors.white), // Cart icon
          Icon(Icons.person, size: 28, color: Colors.white), // Profile icon
        ],
        color: Color(0xFF00A859), // Tokopedia-inspired green for background
        buttonBackgroundColor: Color(0xFF00994E), // Slightly darker green for selected tab
        backgroundColor: Colors.transparent, // Transparent background for overall layout
        animationCurve: Curves.easeInOut, // Smooth animation
        animationDuration: const Duration(milliseconds: 300), // Animation duration
        onTap: _onItemTapped, // Callback when an item is tapped
      ),

    );
  }
}
