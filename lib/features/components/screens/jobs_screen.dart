import 'package:flutter/material.dart';
import 'package:flutter_job_app/common/widgets.Login_Signup/appBar/appbar.dart';


class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:TAppBar(title:Text("Job House",style:Theme.of(context)
          .textTheme.headlineMedium)),
    );
  }
}
