import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_job_app/features/JobFeed/screens/jobDeatails.dart';
import 'package:get/get.dart';

import '../../../utils/loaders/snackbar_loader.dart';

class JobDetailController extends GetxController {
  static JobDetailController get instance => Get.find();


  final FirebaseAuth _auth = FirebaseAuth.instance;



  /// RECRUITMENT HARE ON BUTTON
  Future<void> recruitmentUpdate(String uploadedBy,String jobId)async{
    User? user = _auth.currentUser;
      final _uid = user!.uid;
      if(_uid == uploadedBy){
        try{
          FirebaseFirestore.instance.collection("jobs").doc(jobId).update({"recruitment":true});
        }
        catch(e){
          TLoaders.errorSnackBar(title:"Action cannot be perform");
        }
      }else{
        TLoaders.errorSnackBar(title:"You cannot perform this action");
        // getJobData();
      }
  }
}