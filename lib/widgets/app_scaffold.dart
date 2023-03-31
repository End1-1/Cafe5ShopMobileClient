import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {

  late final List<Widget> widgets;

  AppScaffold({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        minimum: const EdgeInsets.fromLTRB(5, 35, 5, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: widgets,
        )
      )
    );
  }

}