import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/screens/screensearch.dart';
import 'package:student_record/screens/screenprofile.dart';
import '../database/model.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchScreen())),
              icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder: (BuildContext ctx, List<StudentModel> studentList,
              Widget? child) {
            if (studentList.isEmpty) {
              return const Center(
                child: Text('List Empty'),
              );
            }
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final data = studentList[index];
                return Card(
                  color: Colors.grey,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(index: index)),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(data.image)),
                      radius: 40,
                    ),
                    title: Text(data.name),
                    subtitle: const Text('Click to get info'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.black,
                      onPressed: () {
                        showAlertDialogue(ctx, index);
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: studentList.length,
            );
          },
        ),
      ),
    );
  }

  showAlertDialogue(BuildContext context, int index) {
    Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );
    Widget okButton = ElevatedButton(
      onPressed: () {
        deleteStudent(index);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.blue,
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: Text("Item deleted Successfully"),
            duration: Duration(seconds: 2)));
        Navigator.pop(context);
      },
      child: const Text('Ok'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('AlertDialogue'),
      content: const Text('Do you want to delete ?'),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
