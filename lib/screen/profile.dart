import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screen/home.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/db.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({ Key key }) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DbMethod dbMethod = new DbMethod();

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();

  TextEditingController usernameEdtController = new TextEditingController();
  TextEditingController emailEdtController = new TextEditingController();

  update(){
    Map<String, String> userInfoMap = {
      "name": usernameEdtController.text,
      "email": emailEdtController.text,
    };

    HelperFunction.saveUserEmailSharedPreference(emailEdtController.text);
    HelperFunction.saveUserNameSharedPreference(usernameEdtController.text);

    authenticationMethods
        .updateProfile(emailEdtController.text, )
        .then((value) {
            dbMethod.changeUserEmailProfile(userInfoMap);
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
              child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(
              height: 200,
            ),
            TextField(
              controller: usernameEdtController,
              decoration: textfieldDecoration(Constants.myName),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              controller: emailEdtController,
              decoration: textfieldDecoration(Constants.email),
            ),
            SizedBox(
              height: 15,
            ),

             GestureDetector(
              onTap: () {
                update();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}