import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/database/model.dart';
import 'package:student_record/screens/screenprofile.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<StudentModel> studentList =
      Hive.box<StudentModel>('student_db').values.toList();

  late List<StudentModel> studentDisplay = List<StudentModel>.from(studentList);

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: TextField(
              onChanged: (value) => updateList(value),
              controller: textController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      textController.clear();
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder(
          valueListenable: studentListNotifier,
          builder: (BuildContext ctx, List<StudentModel> studentList,
              Widget? child) {
            return ListView.separated(
              itemBuilder: (ctx, index) {
                final data = studentDisplay[index];
                return Card(
                  color: Colors.grey,
                  child: ListTile(
                    onTap: () {
                      final updatedIndex = studentList.indexWhere((element) =>
                          element.name == studentDisplay[index].name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  index: updatedIndex,
                                )),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: FileImage(
                        File(data.image),
                      ),
                      radius: 40,
                    ),
                    title: Text(data.name),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemCount: studentDisplay.length,
            );
          },
        ),
      ),
    );
  }

  updateList(String value) {
    setState(() {
      studentDisplay = studentList
          .where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
      // print(studentList.indexWhere((element) => element.name == 'Ashly'));
    });
  }
}
