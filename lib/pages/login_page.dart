import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/announcements.dart';
import 'package:kcarv_front/utils/main_vector.dart';

class LoginPage extends StatelessWidget {
  final String pageName;
  final void Function() onSubmit;
  const LoginPage({super.key, required this.pageName, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Center(child: MainVector(height: 150, width: 150)),
          const SizedBox(
            height: 20,
          ),
          Text(
            pageName,
            style: const TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: FormField(
                controller: usernameController,
                hintText: "UserName",
                icon: Icons.person,
                obscureText: false,
              )),
          const SizedBox(
            height: 40,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: FormField(
                controller: passwordController,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              )),
          const SizedBox(
            height: 40,
          ),
          ElevatedButton(
            //Changed the on pressed function temporarily for checking the working of announcements page
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(builder: (context){
                  return pageName=="Admin"? Announcements(isadmin: true): Announcements(isadmin: false);
                })
              ),
              style: ElevatedButton.styleFrom(
                  iconColor: Colors.grey,
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: const SizedBox(
                  width: 300,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )))
        ],
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
