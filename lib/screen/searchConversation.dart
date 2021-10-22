import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screen/chatDetail.dart';
import 'package:chat_app/services/db.dart';
import 'package:chat_app/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DbMethod dbMethod = new DbMethod();
  QuerySnapshot _snapshotSearch;

  TextEditingController searchEdtController = new TextEditingController();

  initialSearch() {
    dbMethod.getUserClientbyUsername(searchEdtController.text).then((value) {
      print(value.toString);
      _snapshotSearch = value;
      setState(() {
        
      });
    });
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomConversation(String username){

    if(username != Constants.myName){
      String chatRoomId = getChatRoomId(username, Constants.myName);
    List<String> users = [
      username,
      Constants.myName
    ];
    Map<String, dynamic> homeMap = {
      "users": users,
      "chatroomId": chatRoomId
    };
    dbMethod.createChatRoom(chatRoomId, homeMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(chatRoomId: chatRoomId,),));
    }else{
      print("Can't send mess to yourself");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
  
    initialSearch();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat App"),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                  top: BorderSide(color: Colors.grey, width: 1),
                )),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(children: [
                  Expanded(
                      child: TextField(
                    controller: searchEdtController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search email....",
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      initialSearch();
                    },
                    child: Icon(Icons.search_sharp),
                  )
                ]),
              ),
              searchList()
            ],
          ),
        ));
  }

  Widget searchList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount:_snapshotSearch != null? _snapshotSearch.docs.length:0,
      itemBuilder: (context, index) {
        return searchDetail(_snapshotSearch.docs[index].data()["name"],
            _snapshotSearch.docs[index].data()["email"]);
      },
    );
  }

  Widget searchDetail(String username, String email) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                email,
                style: TextStyle(
                  fontSize: 15,
                  color:Colors.grey
                ),
              ),
            ],
          ),
          SizedBox(
            width: 50,
          ),
          GestureDetector(
            onTap: (){
              createChatRoomConversation(username);
            },
                      child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                "Chat",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

