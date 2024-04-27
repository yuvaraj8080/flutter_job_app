import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_app/data/repositories/job/jobDetail_repository.dart';
import 'package:flutter_job_app/utils/loaders/snackbar_loader.dart';
import 'package:get/get.dart';

import '../../../common/divider_widget.dart';
import '../../../constants/colors.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobId;

  const JobDetailScreen({
    Key? key,
    required this.uploadedBy,
    required this.jobId,
  }) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany = '';
  String? emailCompany = '';
  int? applicants = 0;
  bool? isDeadlineAvailable = false;

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  void getJobData() async {
    try {
      final userDocs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uploadedBy)
          .get();

      if (!userDocs.exists) {
        return;
      } else {
        setState(() {
          final firstName = userDocs.get('FirstName');
          final lastName = userDocs.get('LastName');
          authorName = '$firstName $lastName';
        });
      }

      final jobDatabase = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .get();

      if (!jobDatabase.exists) {
        return;
      } else {
        setState(() {
          userImageUrl = jobDatabase.get('userImage');
          jobTitle = jobDatabase.get('jobTitle');
          jobDescription = jobDatabase.get('jobDescription');
          recruitment = jobDatabase.get('recruitment');
          emailCompany = jobDatabase.get('email');
          locationCompany = jobDatabase.get('location') ?? ''; // Handle null
          applicants = jobDatabase.get('applicants') ?? 0; // Handle null
          postedDateTimeStamp = jobDatabase.get('createdAt');
          deadlineDateTimeStamp =
              jobDatabase.get('deadlineDateTimeStamp') ?? '';
          deadlineDate = jobDatabase.get('deadlineDate') ?? ''; // Handle null
          if (postedDateTimeStamp != null) {
            var postDate = postedDateTimeStamp!.toDate();
            postedDate = '${postDate.year}/${postDate.month}/${postDate.day}';
          }
          if (deadlineDateTimeStamp != null) {
            var date = deadlineDateTimeStamp!.toDate();
            isDeadlineAvailable = date.isAfter(DateTime.now());
          }
        });
      }
    } catch (e) {
      if (mounted) {
        TLoaders.customToast(message: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobDetailController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(jobTitle ?? '',
                            style: Theme.of(context).textTheme.headlineMedium),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 3, color: Colors.grey),
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                        image: NetworkImage(userImageUrl == null
                                            ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHx-26qVB4sL3d0S0bA31ronzegMlaIQ_yltFJz9T84teKbKVU9AEIyuRRE6qnyZlBArg&usqp=CAU"
                                            : userImageUrl!),
                                        fit: BoxFit.fill)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(authorName ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const SizedBox(height: 4),
                                      Text(locationCompany ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall)
                                    ]),
                              )
                            ]),

                        ///  DIVIDER HARE
                        const dividerWidget(),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(applicants.toString(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(width: 8),
                              Text("Applicants",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(width: 10),
                              const Icon(Icons.how_to_reg_sharp,
                                  color: TColors.primaryColor)
                            ]),

                        /// RECRUITMENT HARE
                        FirebaseAuth.instance.currentUser!.uid !=
                                widget.uploadedBy
                            ? Container()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const dividerWidget(),
                                  Text("Recruitment",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              controller.recruitmentUpdate(
                                                  widget.uploadedBy,
                                                  widget.jobId);
                                            },
                                            child: Text("ON",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium)),

                                        /// OPACITY HARE
                                        Opacity(
                                            opacity:
                                                recruitment == true ? 1 : 0,
                                            child: const Icon(Icons.check_box,
                                                color: Colors.green))
                                      ])
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
