import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/database/model.dart';
import 'package:student_record/screens/screenview.dart';

class AddRecord extends StatefulWidget {
  AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final ageController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Add List'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                          backgroundImage: imageFile != null
                              ? FileImage(File(imageFile!.path))
                                  as ImageProvider
                              : const NetworkImage(
                                  'https://tse1.mm.bing.net/th?id=OIP.uuLTfEMXFApAiu9mcTRhhgHaHa&pid=Api&P=0'),
                          radius: 90),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: (() {
                            pickerImage(ImageSource.gallery);
                          }),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: courseController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Your Course'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: ageController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Your Age'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      onAddStudentButtonClicked();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Student'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickerImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<void> onAddStudentButtonClicked() async {
    final name = nameController.text.trim();
    final course = courseController.text.trim();
    final age = ageController.text.trim();
    final String image;

    if (imageFile == null) {
      image = '';
    } else {
      image = imageFile!.path;
    }

    if (name.isEmpty || age.isEmpty || course.isEmpty || image.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("All Fields are Required!!!"),
          duration: Duration(seconds: 2)));
      return;
    }

    int ageValid = int.parse(age);
    if (ageValid <= 0 || ageValid > 100) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Enter the correct age"),
          duration: Duration(seconds: 2)));
      return;
    }
    RegExp regex = RegExp(r'^[a-zA-Z ]+$');
    if (!regex.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a valid name"),
          duration: Duration(seconds: 2)));
      return;
    }

    if (!regex.hasMatch(course)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a valid course"),
          duration: Duration(seconds: 2)));
      return;
    }

    String nameValid = name;
    String courseValid = course;
    if (nameValid.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a valid name "),
          duration: Duration(seconds: 2)));
      return;
    }
    if (courseValid.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Please enter a valid course "),
          duration: Duration(seconds: 2)));
      return;
    }

    final student =
        StudentModel(name: name, age: age, course: course, image: image);
    addStudent(student);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.greenAccent,
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text("Item added Successfully"),
        duration: Duration(seconds: 2)));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ViewPage()));
  }
}
