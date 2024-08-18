import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/sidebar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.isadmin, required this.email});

  final bool isadmin;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: Sidebar(isAdmin: isadmin),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileInfo(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final ImageProvider img_provider = AssetImage('assets/images/Logonobackground1.png');
    return Container(
      margin: EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        boxShadow: [BoxShadow(color: Colors.black, spreadRadius: 12)],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:  img_provider, // Replace with your profile image URL
          ),
          const SizedBox(height: 10),
          Text(
            isadmin?'Admin':'Member',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem('Full Name:', 'John Doe'),
          _buildInfoItem('Email:', 'johndoe@example.com'),
          _buildInfoItem('Phone:', '+123 456 7890'),
          _buildInfoItem('Address:', '123 Main Street, Springfield'),
          // Add more information items as needed
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: Colors.grey.shade300,),
        child: TextButton.icon(
              icon: Icon(Icons.edit, color: Colors.black,),
              onPressed: () {
                // Add functionality for Edit Profile
              },
              label: const Text('Change Password', style: TextStyle(fontSize: 20.0, color: Colors.black),),
            ),
      ),
    );
  }
}