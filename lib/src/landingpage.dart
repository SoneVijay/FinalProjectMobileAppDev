import 'package:final_project/src/addTask.dart';
import 'package:final_project/src/settings.dart';
import 'package:final_project/src/taskList.dart';
import 'package:flutter/material.dart';


class landingPage extends StatefulWidget {
  @override
  _landingPageState createState() => _landingPageState();
}

class _landingPageState extends State<landingPage> {
  int pageIndex = 0;
  List<Widget> pageList = <Widget>[
    TaskList(),
    AddTask(),
    settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageList[pageIndex],
        bottomNavigationBar: BottomNavigationBar(

          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
              if (value == 3) {}
            });
            ;
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Task"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
          selectedItemColor: Color(0xffe3644b),
        ));
  }
}

