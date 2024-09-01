import 'package:flutter/material.dart';
import 'package:kcarv_front/utils/main_vector.dart';
import 'package:kcarv_front/pages/login_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  Widget createLoginBox(String name, void Function() onClick) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onClick,
          style: ElevatedButton.styleFrom(
            iconColor: Colors.grey,
            backgroundColor: Colors.grey[350],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          child: const SizedBox(
            width: 100,
            height: 120, child: Icon(Icons.person, size: 60, color: Colors.black87,)),
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        Text(name, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/firstpageBackground.jpeg'), fit: BoxFit.fill),
        ),
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const MainVector(height: 200, width: 200),
                const Padding(padding: EdgeInsets.only(bottom: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    createLoginBox("Admin", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return LoginPage(pageName: "Admin", onSubmit: () => {});
                      }));
                    }),
                    const Padding(padding: EdgeInsets.only(left: 10, right: 10)),
                    createLoginBox("Member", () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return LoginPage(pageName: "Member", onSubmit: () => {});
                      }));
                    })
                  ],
                )
              ]),
        
      ),
    );
  }
}
