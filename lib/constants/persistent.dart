import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'image_string.dart';


class Persistent {
  static List<String> jobCategoryList = [
    "Accounting/Finance",
    "Administrative",
    "Advertising/Marketing",
    "Agriculture",
    "Architecture",
    "Arts/Entertainment",
    "Banking",
    "Construction/Facilities",
    "Customer Service",
    "Education/Training",
    "Engineering",
    "Government/Military",
    "Healthcare",
    "Hospitality/Travel",
    "Human Resources",
    "Information Technology",
    "Insurance",
    "Legal",
    "Manufacturing/Production",
    "Media",
    "Nonprofit/Volunteer",
    "Real Estate",
    "Restaurant/Food Service",
    "Retail",
    "Sales",
    "Telecommunications",
    "Transportation/Logistics",
    "Other",
    // Additional categories
    "Automotive",
    "Biotech",
    "Consulting",
    "Design",
    "Distribution/Shipping",
    "Executive",
    "Facilities",
    "General Business",
    "Healthcare",
    "Human Resources",
    "Information Technology",
    "Installation",
    "Insurance",
    "Inventory",
    "Legal",
    "Management",
    "Manufacturing/Production",
    "Marketing",
    "Nonprofit",
    "Pharmaceutical/Biotech",
    "Professional Services",
    "Purchasing/Procurement",
    "Quality Assurance/Safety",
    "Research",
    "Retail",
    "Sales",
    "Science",
    "Skilled Labor/Trades",
    "Strategy/Planning",
    "Supply Chain",
    "Telecommunications",
    "Training",
    "Transportation",
    "Warehouse",
  ];

  Future<void> getMyData() async {
    // Get the current user's UID
    final _auth = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the document for the current user
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(_auth)
        .get();

    // Extract first name and last name from the document
    final firstName = userDoc.get('FirstName');
    final lastName = userDoc.get('LastName');

    // Combine first name and last name into full name
    final authorName = '$firstName $lastName';

    // Assign the full name to the `name` variable
    name = authorName;

    // Extract profile picture and location from the document
    userImage = userDoc.get('ProfilePicture');
    location = userDoc.get('Location');
  }
}
