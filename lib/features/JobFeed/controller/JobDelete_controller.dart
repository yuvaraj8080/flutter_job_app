import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';


class JobDeleteController extends GetxController{
  static JobDeleteController get instance => Get.find();

  /// CREATING THE JOB DELETE POPUP
  void DeleteJobDialog(Callback onevent) async{
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(8),
      title:"Delete JobPost",
      middleText:"Are you sure you want to delete your Job post permanently? This action is not reversible and all of your Job data will be removed permanently.",
      confirm:ElevatedButton(onPressed:onevent,
        style:ElevatedButton.styleFrom(backgroundColor:Colors.red,side:const BorderSide(color:Colors.red)),
        child:const Padding(padding:EdgeInsets.symmetric(horizontal:8),child:Text("Delete")),
      ),
      cancel: OutlinedButton(onPressed:()=> Navigator.of(Get.overlayContext!).pop(),
          child:const Text("Cancel")
      ),
    );
  }

}