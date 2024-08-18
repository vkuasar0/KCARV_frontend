import 'package:flutter/material.dart';
import 'package:kcarv_front/pages/first_page.dart';
import 'package:provider/provider.dart';
import 'package:kcarv_front/providers/auth_provider.dart';
import 'package:kcarv_front/pages/announcements.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: authProvider.jwt == null
              ? const FirstPage()
              : Announcements(isadmin: authProvider.loginType == 'Admin'? true: false)
        );
      },
    );
  }
}
