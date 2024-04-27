import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_job_app/constants/image_string.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/loaders/snackbar_loader.dart';

class JobDetailController extends GetxController {
  static JobDetailController get instance => Get.find();


  final TextEditingController commentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// RECRUITMENT HARE ON BUTTON
  Future<void> recruitmentOnUpdate(String uploadedBy, String jobId) async {
    // bool isRecruitment = true;
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    if (_uid == uploadedBy) {
      try {
        FirebaseFirestore.instance
            .collection("jobs")
            .doc(jobId)
            .update({"recruitment": true});
      } catch (e) {
        TLoaders.errorSnackBar(title: "Action cannot be perform");
      }
    } else {
      TLoaders.errorSnackBar(title: "You cannot perform this action");
    }
  }


  /// RECRUITMENT HARE OFF BUTTON
  Future<void> recruitmentOffUpdate(
    String uploadedBy,
    String jobId,
  ) async {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    if (_uid == uploadedBy) {
      try {
        FirebaseFirestore.instance
            .collection("jobs")
            .doc(jobId)
            .update({"recruitment": false});
      } catch (e) {
        TLoaders.errorSnackBar(title: "Action cannot be perform");
      }
    } else {
      TLoaders.errorSnackBar(title: "You cannot perform this action");
    }
  }


  /// WRITE A COMMENT ON JOB POST
   Future<void> addComment(String jobId) async{
    if(commentController.text.length<4){
      TLoaders.customToast(message:"Comment cannot be less than 5 characters");
    }
    else{
      final _generatedId = const Uuid().v4();
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
        'jobComments':FieldValue.arrayUnion([{
          'userId':FirebaseAuth.instance.currentUser!.uid,
          'commentId':_generatedId,
          'name':name,
          'userImageUrl':userImage,
          'commentBody':commentController.text,
          'time':Timestamp.now(),
        }]),
      });
      await TLoaders.customToast(message:"Your comment has been added");
      commentController.clear();
    }
   }
}
