import 'package:flutter/material.dart';

import 'ball.dart';
import 'bat.dart';

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with TickerProviderStateMixin {
  double ballPositionX, ballPositionY;
  double batPosition = 0;
  double batWidth, batHeight;
  double screenWidth, screenHight;
  double increment = 5;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    ballPositionX = 0;
    ballPositionY = 0;
    
    createAnimation();
    controller.forward();
    super.initState();
  }

  checkBorder() {
    if (ballPositionX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
    }

    if (ballPositionX >= screenWidth - 50 && hDir == Direction.right) {
      hDir = Direction.left;
    }
    if (ballPositionY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
    }

    if (ballPositionY >= screenHight - 50 - batHeight && vDir == Direction.down) {
        if(ballPositionX >= batPosition - 50 && ballPositionX <= (batPosition+ batWidth +50)){
           vDir = Direction.up;
        }
        else{
          controller.stop();
          dispose();
        }
     
    }
  }

  createAnimation() {
    controller =
        AnimationController(vsync: this, duration: Duration(minutes: 5));
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
//      animation = controller.drive(Tween<double>(begin: 0, end: 200));
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? ballPositionX += increment
            : ballPositionX -= increment;
        (vDir == Direction.down)
            ? ballPositionY += increment
            : ballPositionY -= increment;
      });
      checkBorder();
    });
  }

  moveBat(DragUpdateDetails update) {
    safeSetState(() {
      batPosition += update.delta.dx;
    });
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        screenWidth = constraint.maxWidth;
        screenHight = constraint.maxHeight;
        batHeight = screenHight / 20;
        batWidth = screenWidth / 4;
        return Stack(
          children: [
            Positioned(child: Ball(), top: ballPositionY, left: ballPositionX),
            Positioned(
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                    child: Bat(
                  batWidth: batWidth,
                  batHeight: batHeight,
                ),
              ),
              bottom: 0,
              left: batPosition,
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void safeSetState(Function function){
    if(mounted && controller.isAnimating){
      setState(() {
        function();
      });
    }
  }
}

enum Direction {
  up,
  down,
  left,
  right //fixed number of constant value
}
