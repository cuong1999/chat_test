import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'signIn_screen.dart';

import 'package:chat_app/services/db.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  DbMethod dbMethod = new DbMethod();

  TextEditingController usernameEdtController = new TextEditingController();
  TextEditingController emailEdtController = new TextEditingController();
  TextEditingController passwordEdtController = new TextEditingController();

  @override
  void didUpdateWidget(covariant SignUp oldWidget) {
    // TODO: implement didUpdateWidget
    usernameEdtController = new TextEditingController();
    emailEdtController = new TextEditingController();
    passwordEdtController = new TextEditingController();
    super.didUpdateWidget(oldWidget);
  }

  signUpAction() {
    Map<String, String> userInfoMap = {
      "name": usernameEdtController.text,
      "email": emailEdtController.text,
    };
    // HelperFunction.saveUserLoggedInSharedPreference(true);
    HelperFunction.saveUserEmailSharedPreference(emailEdtController.text);
    HelperFunction.saveUserNameSharedPreference(usernameEdtController.text);

    setState(() {
      this.isLoading = true;
    });
    authenticationMethods
        .signUp(emailEdtController.text, passwordEdtController.text)
        .then((value) {
      // print("$value");


      dbMethod.updateUserProfile(userInfoMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
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
            height: 200,
          ),
          TextField(
            controller: usernameEdtController,
            decoration: textfieldDecoration("Username"),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            controller: emailEdtController,
            decoration: textfieldDecoration("Email"),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            obscureText: true,
            controller: passwordEdtController,
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
              signUpAction();
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have acount? ",
                style: TextStyle(color: Colors.black, fontSize: 13),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignIn(),
                      ));
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
