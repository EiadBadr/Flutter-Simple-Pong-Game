import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double batWidth, batHeight;

  const Bat({@required this.batWidth,
  @required this.batHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
      height:batHeight ,
      width: batWidth,
      color: Colors.blue[900],
     // decoration: BoxDecoration(shape: BoxShape.circle)
    );
  }
}