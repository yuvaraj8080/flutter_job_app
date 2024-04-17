import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// [JOB FORM  TEXT]
class JobFormText extends StatelessWidget {
  const JobFormText({
    super.key,
    required this.label,
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Text(label, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}