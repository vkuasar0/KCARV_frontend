import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:kcarv_front/utils/main_vector.dart';

class LoginPage extends StatefulWidget {
  final String pageName;
  final void Function() onSubmit;
  const LoginPage({super.key, required this.pageName, required this.onSubmit});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> login() async {
      setState(() {
        _isLoading = true;
      });
      final String apiUrl = widget.pageName == "Admin"
          ? 'https://kcarv-backend.onrender.com/api/login/admin'
          : 'https://kcarv-backend.onrender.com/api/login/member';

      try {
        // Create the request body
        var body = jsonEncode({
          'email': usernameController.text,
          'password': passwordController.text
        });

        // Send POST request to login endpoint
        var response = await http.post(
          Uri.parse(apiUrl),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        // Check if the login was successful
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          String token = data['token']; // Assuming the token is returned in the response body

          await context.read<AuthProvider>().login(token, widget.pageName, usernameController.text);
          Navigator.of(context).pop();
        } else {
          // Handle login failure (show error message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${response.body}')),
          );
        }
      } catch (error) {
        // Handle network or other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 159, 55),
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 206, 159, 55),),
      body: _isLoading? const Center(child: CircularProgressIndicator()): SingleChildScrollView(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Center(child: MainVector(height: 150, width: 150)),
            const SizedBox(height: 20),
            Text(widget.pageName, style: const TextStyle(fontSize: 25)),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: FormField(
                controller: usernameController,
                hintText: "Username",
                icon: Icons.person,
                obscureText: false,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: FormField(
                controller: passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: login, // Trigger login on button press
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const SizedBox(
                width: 300,
                height: 50,
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  const FormField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.icon,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return null;
      },
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
          borderSide: const BorderSide(
            color: Colors.black, // Border color
            width: 1.0, // Border width
          ),
        ),
        hintText: hintText,
        prefixIcon: Icon(icon), // Icon to the left
      ),
    );
  }
}
