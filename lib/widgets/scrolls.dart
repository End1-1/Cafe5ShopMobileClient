import 'package:flutter/cupertino.dart';

class ScrollVH extends StatelessWidget {
  final Widget child;

  const ScrollVH(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: child)));
  }
}
