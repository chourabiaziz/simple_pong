import 'package:flutter/material.dart';

class Raquette extends StatelessWidget {
  final double width;
  final double height;

Raquette(this.width,this.height) ;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height :height ,
      decoration: const BoxDecoration(color: Color.fromRGBO(55,139,244, 244) ),

    );
  }
}
