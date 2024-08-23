import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kcarv_front/pages/sidebar.dart';
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = fetchUserData();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final url = Uri.parse('https://kcarv-backend.onrender.com/api/user/me');
    final response = await http.get(url, headers: {
      'authorization': Provider.of<AuthProvider>(context, listen: false).jwt!
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      drawer: Sidebar(isAdmin: widget.isAdmin),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            final name = userData['name'] ?? 'N/A';
            final email = userData['email'] ?? 'N/A';
            final role = userData['role'] ?? 'N/A';

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(name, email, role),
                  _buildProfileInfo(name, email),
                  _buildActionButtons(),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String email, String role) {
    const ImageProvider imgProvider =
        AssetImage('assets/images/Logonobackground1.png');
    return Container(
      margin: const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
        shape: BoxShape.rectangle,
        boxShadow: const [BoxShadow(color: Colors.black, spreadRadius: 12)],
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: imgProvider, // Replace with your profile image URL
          ),
          const SizedBox(height: 10),
          Text(
            role,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String name, String email) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem('Full Name:', name),
          _buildInfoItem('Email:', email),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.shade300,
        ),
        child: TextButton.icon(
          icon: const Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            // Add functionality for Edit Profile
          },
          label: const Text(
            'Change Password',
            style: TextStyle(fontSize: 20.0, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
