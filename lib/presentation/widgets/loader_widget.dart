import 'package:flutter/material.dart';

class SemitransparentLoader extends StatelessWidget {
  const SemitransparentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: new Color.fromRGBO(220, 220, 220, 0.5),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
