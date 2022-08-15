import 'dart:async';

import 'package:flutter/material.dart';
import 'package:perso/helper/authenticate.dart';

class MySplash extends StatefulWidget {
  const MySplash({Key? key}) : super(key: key);

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        (() => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Authenticate()))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.cyan[900]),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50.0,
                    child: Icon(
                      Icons.chat,
                      color: Colors.greenAccent,
                      size: 50.0,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.0)),
                  Text(
                    "Let's Chat",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(top: 20.0))
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
