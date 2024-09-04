import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLanding();
  }

  void _navigateToLanding() {
    Timer(Duration(seconds: 3), () {
      context.go('/landing'); // Using GoRouter to navigate
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? _buildCupertinoSplash() : _buildMaterialSplash();
  }

  Widget _buildMaterialSplash() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Catbreeds',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              'assets/images/cat_icon.png',
              width: 200,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoSplash() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Catbreeds',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
            const SizedBox(height: 20.0),
            Image.asset(
              'assets/images/cat_icon.png',
              width: 200,
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
