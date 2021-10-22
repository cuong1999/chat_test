import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/db.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
  String textAlert = "";

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  DbMethod dbMethod = new DbMethod();
  TextEditingController emailEdtController = new TextEditingController();
  TextEditingController passwordEdtController = new TextEditingController();

  QuerySnapshot _snapshotInfo;

  @override
  void didUpdateWidget(covariant SignIn oldWidget) {
    // TODO: implement didUpdateWidget

    emailEdtController = new TextEditingController();
    passwordEdtController = new TextEditingController();
    super.didUpdateWidget(oldWidget);
  }

  signInAction() async {
    setState(() {
      isLoading = true;
    });

    await authenticationMethods
        .signIn(emailEdtController.text, passwordEdtController.text)
        .then((result) async {
      if (result != null) {
        // QuerySnapshot userInfoSnapshot =
        //     await DbMethod().getUserClientbyEmail(emailEdtController.text);
        QuerySnapshot userInfoSnapshot =
            await DbMethod().getListClient();
        for (int i = 0; i < userInfoSnapshot.docs.length; i++) {
          if (emailEdtController.text ==
              userInfoSnapshot.docs[i].data()["email"]) {
            HelperFunction.saveUserNameSharedPreference(
                userInfoSnapshot.docs[i].data()["name"]);
            HelperFunction.saveUserEmailSharedPreference(
                userInfoSnapshot.docs[i].data()["email"]);
            break;
          }
          else{
             setState(() {
          isLoading = false;
          textAlert = "Email or password incorrect!";
        });
          }
        }

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      } else {
        setState(() {
          isLoading = false;
          textAlert = "Email or password incorrect!";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          child: body(context),
        ),
      )),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 300,
          ),
          TextField(
            controller: emailEdtController,
            decoration: textfieldDecoration("Email"),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: passwordEdtController,
            obscureText: true,
            decoration: textfieldDecoration("Password"),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Text(
              'Forgot password?',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              signInAction();
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: textAlert == "" ? 0 : 5),
          textAlert != ""
              ? Text(
                  textAlert,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              : Container(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have acount? ",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              Text(
                "Register",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
