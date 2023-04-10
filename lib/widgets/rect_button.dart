import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String assetPath;

  RectButton({required this.onTap, required this.title, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: const BoxDecoration(
          color: Colors.indigo,
          border: Border.fromBorderSide(BorderSide(color: Colors.yellow))
        ),
        height: 90,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, width: 30, height: 40,),
            Expanded(child: Container()),
            Text(title.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
            Expanded(child: Container()),
          ],
        )
      )
    );
  }

}