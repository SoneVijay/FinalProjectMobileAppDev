import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user_id, task_userId;

  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      Firestore.instance
          .collection('user')
          .document(user.uid)
          .get();
        if (user != null) {
          user_id = user.uid.toString();
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

  Future getTasks() async {
    FirebaseUser user = await _auth.currentUser();
    user_id = user.uid;
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('task').where('user_id', isEqualTo: user_id).getDocuments();
    return qn.documents;
  }

  Future deletetask(String taskId) async {
    try {
      return await Firestore.instance
          .collection('task')
          .document(taskId)
          .delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: getTasks(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              //
              return ListView.builder(
                  itemCount:  snapshot.data != null ? snapshot.data.length : 0,
                  itemBuilder: (_, index) {
                    return Dismissible(
                      key: Key(UniqueKey().toString()),
                      onDismissed: (direction) async {
                        deletetask(snapshot.data[index].reference.documentID);
                      },
                      child: ListTile(
                        leading: Image(
                          image: AssetImage("lib/images/logo.png"),
                          fit: BoxFit.contain,
                        ),
                        title:
                            Text(snapshot.data[index].data["task_Name"]),
                        subtitle: Text("${snapshot.data[index].data["task_Description"]} ${snapshot.data[index].data["task_Date".toString()]}"),
                      ),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete_forever_sharp,
                          color: Colors.white,
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
