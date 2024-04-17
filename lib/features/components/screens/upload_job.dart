import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_job_app/utils/halpers/helper_function.dart';
import '../../../constants/colors.dart';
import '../../../constants/persistent.dart';
import '../../../constants/sizes.dart';
import '../models/JobTextFormField.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({super.key});

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final TextEditingController _jobCategoryController = TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController = TextEditingController();
  final TextEditingController _deadlineDataController = TextEditingController(text:"Job Deadline Date");
  final _formKey = GlobalKey<FormState>();
  DateTime? picked;
  Timestamp? deadlineDeadTimeStamp;


  /// JOB TASK CATEGORY
  _showTaskCategoriesDialog({required Size size}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text("Job Category", textAlign: TextAlign.center),
              content: Container(
                  width: size.width *0.95,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Persistent.jobCategoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(onTap: () {
                        setState(() {
                          _jobCategoryController.text = Persistent.jobCategoryList[index];
                        });
                        Navigator.pop(context);
                      },
                      child:Row(children:[
                        const Icon(Icons.arrow_right_outlined),
                        Padding(padding:EdgeInsets.all(5),
                        child:Text(Persistent.jobCategoryList[index])
                        )
                      ])
                      );
                    },
                  )),
            actions:[
              TextButton(onPressed:(){
                Navigator.pop(context);
              }, child: Text("Cancel",style:Theme.of(context).textTheme.headlineSmall,))
            ]
          );
        });
  }

  /// JOB DATE DEADLINE
  void _pickDateDialog()async{
    picked = await showDatePicker(
        context: context,
        initialDate:DateTime.now(),
        firstDate:DateTime.now().subtract(const Duration(days:0)),
        lastDate: DateTime(2100)
    );
    if(picked != null){
      setState((){
        _deadlineDataController.text = "${picked!.year} / ${picked!.month} / ${picked!.day}";
        deadlineDeadTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(picked!.microsecondsSinceEpoch);
      });

    }
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dark = THelperFunction.isDarkMode(context);
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Please fill all fields",
                            style: Theme.of(context).textTheme.headlineMedium),
                      )),
                  const SizedBox(height: TSizes.size4),
                  Divider(
                      thickness: 1,
                      color: dark ? TColors.light : TColors.darkGrey),

                  /// CREATING A JOB FORM
                  Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///JOB CATEGORY TEXTFORM FIELD
                              const JobFormText(label: 'Job Category'),
                              TextFormField(
                                  key:ValueKey("Job Category"),
                                  controller: _jobCategoryController,
                                  enabled: true,
                                  onTap:(){_showTaskCategoriesDialog(size:size);},
                              ),


                              /// JOB TITLE TEXTFROMFIELD
                              const JobFormText(label: 'Job title'),
                              JobTextFormField(
                                  valueKey: "Job title",
                                  controller: _jobTitleController,
                                  enabled: true,
                                  fct: () {},
                              ),

                              /// JOB DESCRIPTION TEXTFROMFIELD
                              const JobFormText(label: 'JobDescription'),
                              JobTextFormField(
                                  valueKey: "JobDescription",
                                  controller: _jobDescriptionController,
                                  enabled: true,
                                  fct: () {},
                              ),

                              ///JOB DEADLINE DATE CONTROLLER
                              const JobFormText(label: 'Job Deadline Date'),
                              TextFormField(
                                  key: ValueKey("Deadline"),
                                  controller: _deadlineDataController,
                                  enabled: true,
                                  onTap: () {_pickDateDialog();},
                              ),
                            ]),
                      )),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 5, right: 10, bottom: 15),
                      child: OutlinedButton(
                          onPressed: () {},
                          child: const Center(child: Text("Post"))),
                    ),
                  )
                ]))),
          ),
        ));
  }
}

/// [JOB FORM  TEXT]
class JobFormText extends StatelessWidget {
  const JobFormText({
    super.key,
    required this.label,
  });
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Text(label, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}


