import 'package:flutter/material.dart';

class jobPostDates extends StatelessWidget {

  const jobPostDates({
   required this.dateName,
    required this.date
  });

  final String? dateName;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Text(dateName??'',style:Theme.of(context).textTheme.bodyLarge),
            Text(date??'',style:Theme.of(context).textTheme.bodyMedium),
          ]),
    );
  }
}
