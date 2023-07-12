import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:brujula_notopos/pages/ar_screen.dart';
import 'package:brujula_notopos/pages/home_screen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
          duration: 5000,
          splashIconSize: 100,
          splash: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.black),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          nextScreen: LocalAndWebObjectsWidget()),
    );
  }
}
