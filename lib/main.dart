import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:_initialization,
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const MaterialApp(
              home:Scaffold(body:Center(child:Text("A this job Searching App",style:TextStyle(color:Colors.cyan,fontSize:40)))
              )
            );
          }
          else if(snapshot.hasError){
            return const MaterialApp(
                home:Scaffold(body:Center(child:Text("A this job Searching App",style:TextStyle(color:Colors.cyan,fontSize:40)))
                )
            );
          }
          return MaterialApp(
            title:"Job Searching App",
            theme: ThemeData(
              scaffoldBackgroundColor:Colors.black,
              primaryColor:Colors.blue,
              fontFamily:"Signatra"
            ),
            home:Scaffold()
          );
        }
    );
  }
}
