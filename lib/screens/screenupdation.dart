import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/database/model.dart';
import 'package:student_record/screens/screenprofile.dart';

class ScreenUpdation extends StatefulWidget {
  final int index;
  const ScreenUpdation({super.key, required this.index});

  @override
  State<ScreenUpdation> createState() => _ScreenUpdationState();
}

class _ScreenUpdationState extends State<ScreenUpdation> {
  final updatenameController = TextEditingController();
  final updatecourseController = TextEditingController();
  final updateageController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? imageFile;

  @override
  Widget build(BuildContext context) {
    updatenameController.text = studentListNotifier.value[widget.index].name;
    updateageController.text = studentListNotifier.value[widget.index].age;
    updatecourseController.text =
        studentListNotifier.value[widget.index].course;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Update Data'),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                      backgroundImage: imageFile == null
                          ? FileImage(File(
                              studentListNotifier.value[widget.index].image))
                          : FileImage(File(imageFile!.path)),
                      radius: 90),
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: (() {
                          updatedImage(ImageSource.gallery);
                        }),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: updatenameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: updatecourseController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your course',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: updateageController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  onUpdateStudentButtonClicked();
                },
                icon: const Icon(Icons.add),
                label: const Text('Update'),
              )
            ],
          ),
        ),
      )),
    );
  }

  Future<void> updatedImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    setState(() {
      imageFile = pickedFile;
    });
  }

  Future<void> onUpdateStudentButtonClicked() async {
    final updatedname = updatenameController.text.trim();
    final updatedcourse = updatecourseController.text.trim();
    final updatedage = updateageController.text.trim();
    final String updatedimage;
    if (imageFile == null) {
      updatedimage = studentListNotifier.value[widget.index].image;
    } else {
      updatedimage = imageFile!.path;
    }

    if (updatedname.isEmpty || updatedage.isEmpty || updatedcourse.isEmpty
    || updatedimage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("All Fields are Required!!!"),
          duration: Duration(seconds: 2)));
      return;
    }
    
    int ageValid = int.parse(updatedage);
    if (ageValid <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.redAccent,
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text("Age Should be Greater Than 0"),
          duration: Duration(seconds: 2)));
      return;
    }
      final updatedStudent = StudentModel(
          name: updatedname,
          age: updatedage,
          course: updatedcourse,
          image: updatedimage);

      updateStudent(updatedStudent, widget.index);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.greenAccent,
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text("Updated Successfully"),
        duration: Duration(seconds: 2)));
      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(index: widget.index)));
    
  }
}
