import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_pong/balle.dart';
import 'package:simple_pong/raquette.dart';
enum Direction { up, down, left, right }
class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin  {
  double width=5;
  double height=10;
  double increment = 5 ;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  int score =0;
  double posX = 0;
  double posY = 0;
  double raquetteWidth = 0;
  double raquetteHeight = 0;
  double raquettePosition = 0;
  late Animation<double> animation;
  late AnimationController controller;
  double randX = 1;
  double randY = 1;
  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('YOU LOSE!'),
            content: Text('PLAY AGAIN?'),
            actions: <Widget>[
              TextButton(
                child: Text('YES'),
                onPressed: () {
                  setState(() {
                    posX = 0;
                    posY = 0;
                    score = 0;
                  });
                  Navigator.of(context).pop();
                  controller.repeat();
                },
              ),
              TextButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                  dispose();
                },
              )
            ],
          );
        });
  }

  void checkBorders({double diameter = 50}) {
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right){
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height - diameter - raquetteHeight && vDir == Direction.down) {

      if (posX >= (raquettePosition - diameter) && posX <= (raquettePosition + raquetteWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;});
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }

  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }
  double randomNumber() {

    var ran = Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }
  @override
  void initState() {
    posX = 0;
    posY = 0;

    controller = AnimationController(
        duration: const Duration(seconds: 10000),
        vsync:this);
    controller.forward();
    super.initState();
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX+1).round())
            : posX -= ((increment * randX+1).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY+1).round())
            : posY -= ((increment * randY+1).round());
      });
      checkBorders();
    });


  }


  @override
  Widget build(BuildContext context) {
    return Container(decoration: const BoxDecoration(

    ),


      child:   LayoutBuilder(



          builder : (BuildContext context, BoxConstraints constraints) {

            height = constraints.maxHeight;

            width = constraints.maxWidth ;

            raquetteWidth = width / 4;

            raquetteHeight = height / 35;

            return Stack(

              children: <Widget>[

                Positioned(

                  top: 0,

                  right: 145,



                  child: Text(style: TextStyle(color:Color.fromARGB(90,90,90, 55),fontSize:30,fontWeight:FontWeight.bold ), 'Score: $score'),

                ),

                Positioned(child: Balle(), top: posY, left: posX),



                Positioned(

                    bottom: 0,

                    left: raquettePosition,

                    child: GestureDetector(

                        onHorizontalDragUpdate: (DragUpdateDetails update)

                        => moveBat(update),

                        child: Raquette(raquetteWidth, raquetteHeight))

                ),





              ],

            );

          }

      ),
    );

  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void moveBat(DragUpdateDetails update) {
    safeSetState(() {
      raquettePosition += update.delta.dx;
    });
  }


}