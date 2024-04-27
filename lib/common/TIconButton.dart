import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TIconButton extends StatelessWidget {
  const TIconButton({
    super.key, required this.iconName, required this.function
  });

  final Icon iconName;
  final VoidCallback function;


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed:function, icon:iconName);
  }
}
