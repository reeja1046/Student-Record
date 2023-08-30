import 'package:flutter/material.dart';
import 'package:student_record/database/functions.dart';
import 'package:student_record/screens/screenadd.dart';
import 'package:student_record/screens/screenview.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  gotoview(context);
                },
                child: Text('View record')),
            ElevatedButton(
                onPressed: () {
                  gotoadd(context);
                },
                child: Text('Add record')),
          ],
        ),
      ),
    );
  }

  void gotoview(BuildContext ctx) async {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) => ViewPage()));
  }

  void gotoadd(BuildContext ctx) async {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx1) => AddRecord()));
  }
}
