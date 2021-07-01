import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/src/landingpage.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  CollectionReference firestore_task = Firestore.instance.collection("task");
  String user_id,
      task_Name,
      task_Description,
      task_Date;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        var firebaseUser = await FirebaseAuth.instance.currentUser();
        Firestore.instance
            .collection('user')
            .document(firebaseUser.uid)
            .get()
            .then((DocumentSnapshot) => user_id = firebaseUser.uid);
      }
      else{
        Navigator.of(context).pushReplacementNamed("Home");
      }
    });
  }
  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Notification'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Task Added!"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  addTask() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

          await firestore_task.document().setData({
            "user_id":user_id,
            "task_Name": task_Name,
            "task_Description": task_Description,
            "task_Date": task_Date,
          });
        }
      }


  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                  },
                  child: Text('OK'))
            ],
          );
        });
  }
  DateTime _date = DateTime.now();
  Future<Null> selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
      initialDate:_date,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );

    if(picked != null && picked != _date){
      setState(() {

        _date = picked;
      });
    }
    task_Date = DateFormat.yMMMd().format(_date);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                ),
                Container(
                  height: 60,
                ),
                Container(
                  height: 50,
                  child: RichText(
                      text: TextSpan(
                        text: 'Create New Task',

                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black),
                      )),
                ),
                Container(
                  height: 30,
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return '         Enter Task Name';
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Name',
                                prefixIcon: Icon(Icons.addchart_outlined),
                              ),
                              onSaved: (input) => task_Name = input),
                        ),

                        Container(
                          child: TextFormField(
                              validator: (input) {
                                if (input.isEmpty) return '         Enter Task Description';
                              },
                              decoration: InputDecoration(
                                labelText: 'Task Description',
                                prefixIcon: Icon(Icons.addchart_outlined),
                              ),
                              onSaved: (input) => task_Description = input),

                        ),

                        Container(
                          child: TextFormField(
                              decoration: InputDecoration(
                                labelText: task_Date,
                                prefixIcon: IconButton(
                                    onPressed: (){
                                    selectDate(context);
                                  },
                                  icon: Icon(Icons.calendar_today_sharp),
                                ),

                              ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Container(
                          height: 20,
                        ),
                        SizedBox(height: 20),
                        RaisedButton(
                            padding: EdgeInsets.only(
                                left: 120, right: 120, bottom: 18, top: 18),
                            onPressed: (){
                              addTask();
                              if(task_Description != null && task_Name != null ){
                                showDialog(
                                  context: context,

                                  builder: (BuildContext context) => _buildPopupDialog(context),
                                  );
                              }
                              },
                            child: Text(
                              'ADD',
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            color: Color(0xffe3644b)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}