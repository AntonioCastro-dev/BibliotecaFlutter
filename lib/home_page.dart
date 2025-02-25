import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(int) changeTab;

  const HomePage({required this.changeTab});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildListTile(
            context,
            icon: Icons.person,
            text: "My Account",
            onTap: () => changeTab(3),
          ),
          _buildDivider(),
          _buildListTile(
            context,
            icon: Icons.search,
            text: "Search Catalog",
            onTap: () => changeTab(1),
          ),
          _buildDivider(),
          _buildListTile(context, icon: Icons.location_on, text: "Location & Hours"),
          _buildDivider(),
          _buildListTile(context, icon: Icons.library_books, text: "Digital Collections"),
          _buildDivider(),
          _buildListTile(context, icon: Icons.event, text: "Events"),
          _buildDivider(),
          _buildListTile(context, icon: Icons.new_releases, text: "New Arrivals"),
          _buildDivider(),
          _buildListTile(context, icon: Icons.help_outline, text: "How do I?"),
          _buildDivider(),
          _buildListTile(context, icon: Icons.star, text: "Spotlight"),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon, required String text, VoidCallback? onTap}) {
    return Container(
      height: 80, // Altura aumentada
      child: ListTile(
        leading: Icon(icon, size: 56, color: Color.fromARGB(255, 59, 190, 50)),
        title: Text(text, style: TextStyle(fontSize: 18)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey, thickness: 1);
  }
}
