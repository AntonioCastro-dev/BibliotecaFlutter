import 'package:flutter/material.dart';
import 'home_page.dart';
import 'catalogo_screen.dart';
import 'carnet_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    // Se inicializa la lista de pantallas pasando la función _onItemTapped a HomePage.
    _screens.add(HomePage(changeTab: _onItemTapped));
    _screens.add(CatalogoScreen());
    _screens.add(CarnetScreen());
    _screens.add(ProfileScreen());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.network(
            'https://miro.medium.com/v2/resize:fit:1400/1*6Jp3vJWe7VFlFHZ9WhSJng.jpeg',
            width: double.infinity,
            height: 170,
            fit: BoxFit.cover,
          ),
          AppBar(
            backgroundColor: Colors.blue.shade900,
            title: Center(
              child: Text(
                _getTitle(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            leading: _selectedIndex == 0
                ? null
                : IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                  ),
          ),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue.shade900,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 32), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 32), label: ''), // Lupa
          BottomNavigationBarItem(
              icon: Icon(Icons.credit_card, size: 32), label: ''), // Carnet
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 32), label: ''),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        onTap: _onItemTapped,
      ),
    );
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Catálogo';
      case 2:
        return 'Carnet de Biblioteca';
      case 3:
        return 'Perfil';
      default:
        return '';
    }
  }
}
