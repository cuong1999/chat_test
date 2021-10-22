import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screen/profile.dart';
import 'package:chat_app/screen/searchConversation.dart';
import 'package:chat_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';

import 'chatDetail.dart';
import 'signUp_screen.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthenticationMethods authenticationMethods = new AuthenticationMethods();

  Stream chatRooms;

  @override
  void initState() {
    getInfo();
    // TODO: implement initState
    super.initState();
  }

  getInfo()async{
    Constants.myName = await HelperFunction.getUserNameSharedPreference();
    Constants.email = await HelperFunction.getUserEmailSharedPreference();
    DbMethod().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: [
          GestureDetector(
            onTap: () {
              authenticationMethods.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUp(),), (route) => false);
            },
                      child: Container(
              child: Icon(Icons.exit_to_app)
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Profile(),), (route) => false);
            },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.person_rounded)
            ),
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search(),));
        },
      ),
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return chatRoomTitle(
                     snapshot.data.docs[index].data()['chatroomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    snapshot.data.docs[index].data()["chatroomId"],
                  );
                })
            : Container();
      },
    );
  }

  
  Widget chatRoomTitle(String userName, String chatRoomId){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Chat(
            chatRoomId: chatRoomId,
          )
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
