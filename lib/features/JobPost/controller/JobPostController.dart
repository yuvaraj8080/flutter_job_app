import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_app/utils/loaders/snackbar_loader.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../common/NetworkManager/network_manager.dart';
import '../../../constants/image_string.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../personalization/controllers/user_controller.dart';


class JobController extends GetxController {
  static JobController get instance => Get.find();
  DateTime? picked;
  Timestamp? deadlineDeadTimeStamp;
  final jobCategoryController = TextEditingController(text: "Select Job Category");
  final jobTitleController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final deadlineDataController = TextEditingController(text: "Job Deadline Date");
  GlobalKey<FormState> formKey = GlobalKey();


  /// JOB UPLOAD TASK HERE
  Future<void> uploadTask() async {


    /// FULL SCREEN LOADING HERE
    TFullScreenLoader.openLoadingDialog("We are processing your information...",
        "assets/images/animations/loading.json");

    final jobId = const Uuid().v4();
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: "Authentication Error", message: "User is not logged in.");
      return;
    }
    final _db = FirebaseFirestore.instance;
    final _uid = user.uid;

    /// CHECK INTERNET CONNECTIVITY
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: "Connection Error", message: "No internet connection.");
      return;
    }

    /// FORM VALIDATION
    if (!formKey.currentState!.validate()) {
      TFullScreenLoader.stopLoading();
      return;
    }

    if (deadlineDataController.text == "Choose job Deadline date") {
      TFullScreenLoader.stopLoading();
      TLoaders.warningSnackBar(title: "Date Required", message: "Please pick a deadline date for the job.");
      return;
    }

    /// UPLOAD POST DATA IN FIRESTORE
    try {
      final controller = Get.put(UserController());
      name  = controller.user.value.fullName;
      userImage = controller.user.value.profilePicture;
      location  = controller.user.value.location;



      await _db.collection('jobs').doc(jobId).set({
        'jobId': jobId,
        'uploadedBy': _uid,
        'email': user.email ?? '',
        'jobTitle': jobTitleController.text.trim(),
        'jobDescription': jobDescriptionController.text.trim(),
        'deadlineDate': deadlineDataController.text.trim(),
        'deadlineDateTimeStamp': deadlineDeadTimeStamp,
        'jobCategory': jobCategoryController.text.trim(),
        'jobComments': [],
        'recruitment': true,
        'createdAt': Timestamp.now(),
        'name': name, // This should be replaced with the actual user's name
        'userImage': userImage, // This should be replaced with the actual user's image
        'location': location, // This should be replaced with the actual user's location
        'applicants': 0,
      });

      await TLoaders.customToast(message: "Job post uploaded successfully");

      jobTitleController.clear();
      jobDescriptionController.clear();


    } catch (e) {
      TLoaders.errorSnackBar(title: "Oh Snap!", message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }
}
