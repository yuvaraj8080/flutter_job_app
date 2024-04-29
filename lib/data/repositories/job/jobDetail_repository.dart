import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_job_app/common/divider_widget.dart';
import 'package:flutter_job_app/constants/image_string.dart';
import 'package:flutter_job_app/features/JobFeed/widgets/comments.dart';
import 'package:flutter_job_app/utils/shimmer_circular_Indicator/shimmer.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../features/JobFeed/screens/jobDeatails.dart';
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




/// COMMENT DOCUMENT SNAPSHOT FROM BACKAND
class Show_Comment_Method extends StatelessWidget {
  const Show_Comment_Method({
    super.key,
    required this.widget,
  });

  final JobDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get(),
      builder:(context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const  TShimmerEffect(width:double.infinity, height:double.infinity);
        }
        else{
          if(snapshot.data == null){
            const Center(child:Text("No comments for this job"));
          }
        }
        return ListView.separated(
          shrinkWrap: true,physics:const NeverScrollableScrollPhysics(),
          itemBuilder:(context, index){
            return CommentScreen(
              commentId: snapshot.data!['jobComments'][index]["commentId"]??'',
              commenterId: snapshot.data!['jobComments'][index]["userId"]??'',
              commenterName: snapshot.data!['jobComments'][index]["name"]??'',
              commentBody: snapshot.data!['jobComments'][index]["commentBody"]??'',
              commenterImageUrl: snapshot.data!['jobComments'][index]["userImageUrl"]??'',
            );
          },
          separatorBuilder: (context, index){
            return const dividerWidget();
          },
          itemCount: snapshot.data!['jobComments'].length,
        );
      },
    );
  }
}
