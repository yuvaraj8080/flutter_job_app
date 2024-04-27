import 'package:flutter/material.dart';

class dividerWidget extends StatelessWidget {
  const dividerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      SizedBox(height:10),
      Divider(
          thickness:1,color:Colors.grey
      ),
      SizedBox(height:10)
    ],);
  }
}