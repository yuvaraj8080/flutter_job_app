import 'package:flutter/material.dart';

class JobCardScreen extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobCardScreen(
      {required this.jobTitle,
      required this.jobDescription,
      required this.jobId,
      required this.uploadedBy,
      required this.userImage,
      required this.name,
      required this.recruitment,
      required this.email,
      required this.location});

  @override
  State<JobCardScreen> createState() => _JobCardScreenState();
}

class _JobCardScreenState extends State<JobCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            onTap: () {},
            onLongPress: () {},
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            leading: Container(
              padding: const EdgeInsets.only(right: 12),
              decoration: const BoxDecoration(
                  border: Border(
                right: BorderSide(width: 1),
              )),
              child: Image.network(widget.userImage),
            ),
            title: Text(widget.jobTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall),
            subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(widget.jobDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall),
                ]),
            trailing: const Icon(Icons.keyboard_arrow_right, size: 30)));
  }
}
