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
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          child: SizedBox(
            width: 100,
            height: 120, child: Icon(Icons.person, size: 60,)),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
        Text(name)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const MainVector(height: 200, width: 200),
                const Padding(padding: EdgeInsets.only(bottom: 200)),
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
