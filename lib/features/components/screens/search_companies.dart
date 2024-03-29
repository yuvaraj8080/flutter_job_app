import 'package:flutter/material.dart';

import '../../../common/widgets.Login_Signup/appBar/appbar.dart';

class SearchCompany extends StatelessWidget {
  const SearchCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:TAppBar(title:Text("Search Screen",style:Theme.of(context).textTheme.headlineMedium))
    );
  }
}
