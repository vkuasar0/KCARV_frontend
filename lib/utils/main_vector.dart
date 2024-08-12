import 'package:flutter/material.dart';

class MainVector extends StatelessWidget {
  final double height;
  final double width;
  const MainVector({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
                  width: width,
                  height: height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('assets/images/Logonobackground1.png'),
                        fit: BoxFit.fitWidth),
                  ));
  }
}