import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/src/loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'Widget/bezierContainer.dart';

class settings extends StatefulWidget {
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<settings> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String user_id, user_username;

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

  signOut() async {
    _auth.signOut();
    Navigator.pushReplacementNamed(context, "Login");
  }

  Widget logoutButton( Function function){
    return Padding(
      padding: const EdgeInsets.only(top: 18,right: 16),
      child: Row( mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed:signOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50,),
              child: Text('LOGOUT',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600),),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xffe3644b),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getUserInfo() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn =
    await firestore.collection('user').getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    getUserInfo();
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      Container(
                        alignment: Alignment.center,
                        height: 150,
                        child: Image(
                          image: AssetImage("lib/images/logo.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      logoutButton((){}),


                      SizedBox(height: height * .18),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ));
  }
}
