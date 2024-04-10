import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hive_database_demo/pages/home_page.dart';

class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation = new CurvedAnimation(
        parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/hive.jpg',
                width: animation!.value * 250,
                height: animation!.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MyHomePage(),
    ));
  }
}
