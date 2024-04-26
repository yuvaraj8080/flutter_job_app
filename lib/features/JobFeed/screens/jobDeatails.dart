import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_app/utils/loaders/snackbar_loader.dart';

class JobDetailScreen extends StatefulWidget {
  final String uploadedBy;
  final String jobId;

  const JobDetailScreen({
    super.key,
    required this.uploadedBy,
    required this.jobId,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  String? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? locationCompany;
  String? emailCompany;
  int? applicants;
  bool? isDeadlineAvailable; // Change to bool?

  @override
  void initState() {
    super.initState();
    getJobData();
  }

  /// CREATING A METHOD TO FETCH THE JOB DETAIL DATA FROM THE BACKEND
  void getJobData() async {
    try {
      final DocumentSnapshot userDocs = await FirebaseFirestore.instance
          .collection('User')
          .doc(widget.uploadedBy)
          .get();

      if (userDocs.exists) {
        setState(() {
          authorName = userDocs.get('FirstName');
          userImageUrl = userDocs.get('ProfilePicture');
        });
      }

      final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .get();

      if (jobDatabase.exists) {
        setState(() {
          jobTitle = jobDatabase.get('jobTitle');
          jobDescription = jobDatabase.get('jobDescription');
          recruitment = jobDatabase.get('recruitment');
          emailCompany = jobDatabase.get('email');
          locationCompany = jobDatabase.get('location');
          applicants = jobDatabase.get('applicants');
          postedDateTimeStamp = jobDatabase.get('createdAt');
          deadlineDateTimeStamp = jobDatabase.get('deadline');

          if (postedDateTimeStamp != null) {
            var postedDateData = postedDateTimeStamp!.toDate();
            postedDate = '${postedDateData.year}/${postedDateData.month}/${postedDateData.day}';
          }

          if (deadlineDateTimeStamp != null) {
            var deadlineData = deadlineDateTimeStamp!.toDate();
            deadlineDate = '${deadlineData.year}/${deadlineData.month}/${deadlineData.day}';
            isDeadlineAvailable = deadlineData.isAfter(DateTime.now());
          }
        });
      }
    } catch (e) {
      if (mounted) {
        TLoaders.customToast(message:e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobTitle ?? ''),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
