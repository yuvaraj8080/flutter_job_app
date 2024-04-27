import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../constants/colors.dart';
import '../../../constants/persistent.dart';
import '../../../constants/sizes.dart';
import '../../../utils/halpers/helper_function.dart';
import '../controller/JobPostController.dart';
import '../models/JobFormText.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({super.key});

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {

  _showTaskCategoriesDialog({required Size size}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Job Category", textAlign: TextAlign.center),
          content: Container(
            width: size.width * 9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: Persistent.jobCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    final controller = Get.find<JobController>();
                    controller.jobCategoryController.text =
                        Persistent.jobCategoryList[index];
                    Navigator.pop(context);
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
              child: Text("Cancel",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ],
        );
      },
    );
  }

  /// JOB DATE DEADLINE
  void _pickDateDialog() async {
    final controller = Get.find<JobController>();
    controller.picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (controller.picked != null) {
      controller.deadlineDataController.text =
          "${controller.picked!.year}/${controller.picked!.month}/${controller.picked!.day}";
      controller.deadlineDeadTimeStamp = Timestamp.fromMillisecondsSinceEpoch(
          controller.picked!.millisecondsSinceEpoch);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobController());
    Size size = MediaQuery.of(context).size;
    final dark = THelperFunction.isDarkMode(context);


    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Please fill all fields",
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                    const SizedBox(height: TSizes.size4),
                    Divider(
                        thickness: 1,
                        color: dark ? TColors.light : TColors.darkGrey),
                    const JobFormText(label: 'Job Category'),
                    TextFormField(
                      controller: controller.jobCategoryController,
                      onTap: () => _showTaskCategoriesDialog(size: size),
                      validator: (value) =>
                          value!.isEmpty ? 'Please select a category' : null,
                    ),
                    const JobFormText(label: 'Job title'),
                    TextFormField(
                      controller: controller.jobTitleController,
                      validator: (value) =>
                          value!.isEmpty ? 'Job title cannot be empty' : null,
                    ),
                    const JobFormText(label: 'Job Description'),
                    TextFormField(
                      controller: controller.jobDescriptionController,
                      validator: (value) => value!.isEmpty
                          ? 'Job description cannot be empty'
                          : null,
                    ),
                    const JobFormText(label: 'Job Deadline Date'),
                    TextFormField(
                      controller: controller.deadlineDataController,
                      onTap: _pickDateDialog,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: OutlinedButton(
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.uploadTask();
                            }
                          },
                          child: const Text("Post Job"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


