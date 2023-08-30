
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/database/model.dart';
import 'package:student_record/screens/screenupdation.dart';

class ProfileScreen extends StatefulWidget {
  final int index;
  const ProfileScreen({super.key,required this.index});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: studentListNotifier,
        builder:
            (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
          final data = studentList[widget.index];
          return Scaffold(
            backgroundColor: Colors.grey,
              appBar: AppBar(
                title: const Text('Profile'),
              ),
              body: SafeArea(
                 child: Column(
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 80,
                     backgroundImage: FileImage(File(data.image)),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        Column(
                          children: [
                                            
                            display("Name:", data.name.toUpperCase()),
                            
                            display("Age:", data.age),
                           
                            display("Course:", data.course),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenUpdation(index: widget.index)),
                                );
                              },
                              
                              icon: const Icon(Icons.add),
                              label: const Text('Update',style: TextStyle(fontSize: 18),),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }

  Widget display(field, data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          field,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          data,
          style: const TextStyle(fontSize: 20),
        )
      ],
    );
  }

}


