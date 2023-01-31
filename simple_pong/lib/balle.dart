import 'package:flutter/material.dart';
class Balle extends StatelessWidget {
  const Balle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

        width: 20,
        height : 20 ,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        )
    );
  }
}
