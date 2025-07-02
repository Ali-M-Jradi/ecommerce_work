import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade700,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.deepPurpleAccent.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.deepPurpleAccent.shade700),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.deepPurpleAccent.shade700),
            title: Text('Account'),
            subtitle: Text('Manage your profile'),
            onTap: () {
              // Handle account tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.deepPurpleAccent.shade700),
            title: Text('Shopping Cart'),
            onTap: () {
              // Handle shopping cart tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.deepPurpleAccent.shade700),
            title: Text('Favorites'),
            onTap: () {
              // Handle favorites tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: Colors.deepPurpleAccent.shade700),
            title: Text('Location'),
            subtitle: Text('Set delivery address'),
            onTap: () {
              // Handle location tap
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.deepPurpleAccent.shade700),
            title: Text('Language'),
            subtitle: Text('Change app language'),
            onTap: () {
              // Handle language change
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_support, color: Colors.deepPurpleAccent.shade700),
            title: Text('Contact Us'),
            onTap: () {
              // Handle contact us tap
              Navigator.pop(context);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.deepPurpleAccent.shade700),
            title: Text('Settings'),
            onTap: () {
              // Handle settings tap
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}