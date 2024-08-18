import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/sidebar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.isadmin});

  final bool isadmin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      drawer: Sidebar(isAdmin: isadmin),
      body: Center(
        child: Text("This is the profile page"),
      ),
    );
  }
}