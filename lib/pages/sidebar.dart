import 'package:flutter/material.dart';
import 'package:kcarv_front/main.dart';
import 'package:kcarv_front/pages/announcements.dart';
import 'package:kcarv_front/pages/events.dart';
import 'package:kcarv_front/pages/inventory.dart';
import 'package:kcarv_front/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:kcarv_front/providers/auth_provider.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
              child: Image.asset(
            'assets/images/Logonobackground1.png',
            fit: BoxFit.contain,
          )),
          ListTile(
            title: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Announcements(isadmin: isAdmin),
                  ));
                },
                icon: const Icon(Icons.announcement_outlined),
                label: const Text("Announcements")),
          ),
          ListTile(
            title: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => EventsPage(isAdmin: isAdmin)));
                },
                icon: const Icon(Icons.event),
                label: const Text("Events")),
          ),
          ListTile(
            title: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => PDInventoryPage(
                      isAdmin: isAdmin,
                    ),
                  ));
                },
                icon: const Icon(Icons.inventory),
                label: const Text("PD Inventory")),
          ),
          ListTile(
            title: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => Profile(
                      isAdmin: isAdmin,
                    ),
                  ));
                },
                icon: const Icon(Icons.person),
                label: const Text("Profile")),
          ),
          const Divider(),
          ListTile(
            title: TextButton.icon(
                onPressed: () async {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                      (route) => false);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log out")),
          )
        ],
      ),
    );
  }
}
