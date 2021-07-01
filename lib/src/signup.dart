import 'package:flutter/material.dart';
import 'package:final_project/src/Widget/bezierContainer.dart';
import 'package:final_project/src/loginPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CollectionReference firestore_users = Firestore.instance.collection("user");
  String user_username, user_email, _password;


  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) async {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "landingPage");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        AuthResult user = await _auth.createUserWithEmailAndPassword(
            email: user_email.trim(), password: _password);
        if (user != null) {
          await firestore_users.document(user.user.uid).setData({"user_email": user_email, "user_username": user_username});

        }
      } catch (e) {
        showError(e.message);
        print(e);
      }
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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryFieldPassword() {
    return Container(
      child: TextFormField(
          validator: (input) {
            if (input.length < 6)
              return 'Provide Minimum 6 Character';
          },
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
          onSaved: (input) => _password = input),
    );
  }
  Widget _entryFieldEmail() {
    return Container(
      child: TextFormField(
          validator: (input) {
            if (input.isEmpty) return 'Enter Email';
          },
          decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email)),
          onSaved: (input) => user_email = input),
    );
  }
  Widget _entryFieldUsername() {
    return  Container(
      child: TextFormField(
          validator: (input) {
            if (input.isEmpty) return 'Enter Username';
          },
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
          ),
          onSaved: (input) => user_username = input),
    );
  }
  Widget _emailPasswordWidget() {
    return Container(
        child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _entryFieldUsername(),
            SizedBox(height: 10),
            _entryFieldEmail(),
            SizedBox(height: 10),
            _entryFieldPassword(),
            SizedBox(height: 10),
      ],
    )));
  }

  Widget _submitButton() {
    return Container(
    child:
    RaisedButton(
        padding: EdgeInsets.only(left: 120, right: 120,bottom: 18,top: 18),
        onPressed: signUp,
        child: Text(
          'SIGN UP',
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
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: Color(0xffe3644b),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe3644b),
          ),
          children: [
            TextSpan(
              text: 'Procrasti',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'note',
              style: TextStyle(color: Color(0xffe3644b), fontSize: 30),
            ),
          ]),
    );
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
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
                    _title(),
                    SizedBox(
                      height: 10,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .17),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
