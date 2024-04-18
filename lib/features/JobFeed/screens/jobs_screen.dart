import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_job_app/common/Search_Job.dart';
import 'package:flutter_job_app/utils/loaders/snackbar_loader.dart';
import 'package:flutter_job_app/utils/shimmer_circular_Indicator/shimmer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants/persistent.dart';
import '../models/JobCard.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? jobCategoryFilter;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// THIS IS THE JOB CATEGORY FILTER
  _showTaskCategoriesDialog({required Size size}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Job Category", textAlign: TextAlign.center),
          content: Container(
            width: size.width * 0.95,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    jobCategoryFilter = Persistent.jobCategoryList[index];
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right_outlined),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(Persistent.jobCategoryList[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text("Cancel Filter",
                    style: Theme.of(context).textTheme.headlineSmall)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(Icons.filter_list_sharp, size: 30),
                onPressed: () {
                  _showTaskCategoriesDialog(size: size);
                }),
            actions: [
              IconButton(
                  icon:const Icon(Icons.search_rounded, size: 30),
                  onPressed: (){Get.to(()=>const SearchScreen());})
            ]),
        body:StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('jobs')
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy("createdAt", descending: false)
              .snapshots(),
          builder:(context,AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child:TShimmerEffect(width:double.infinity, height:double.infinity),);
            }
            else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data?.docs.isNotEmpty == true){
                return ListView.builder(
                    itemCount:snapshot.data?.docs.length,
                    itemBuilder:(BuildContext context, int index){
                      return JobCardScreen(
                        jobTitle:snapshot.data?.docs[index]['jobTitle'],
                        jobDescription:snapshot.data?.docs[index]['jobDescription'],
                        jobId:snapshot.data?.docs[index]["jobId"],
                        uploadedBy:snapshot.data?.docs[index]["uploadedBy"],
                        userImage:snapshot.data?.docs[index]["userImage"]??'',
                        name:snapshot.data?.docs[index]["name"],
                        recruitment: snapshot.data?.docs[index]["recruitment"], // Handle as boolean
                        email:snapshot.data?.docs[index]["email"],
                        location:snapshot.data?.docs[index]["location"],

                      );
                    }
                );
              }
              else{
                const Center(child: Text("There is No Jobs"));
              }
            }
            return const Center(child:Text("Something went wrong;"));
          },
        )
    );
  }
}
