import 'dart:io';

import 'package:chat_app/helper/constant.dart';
import 'package:chat_app/services/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  Chat({this.chatRoomId, Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  bool isLike = true;

  File imageFile;
  @override
  void initState() {
    DbMethod().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return messageTitle(
                    // snapshot.data["message"],
                    // Constants.myName ==
                    //     snapshot.data["sendBy"],
                    snapshot.data.docs[index].data()["message"],
                    Constants.myName ==
                        snapshot.data.docs[index].data()["sendBy"],
                        // isLike == snapshot.data.docs[index].data()["like"],
                  );
                })
            : Container();
      },
    );
  }

   _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        uploadImage();
      });
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": imageFile,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      // DbMethod().addMessage(widget.chatRoomId, chatMessageMap);

    }

   
  // ImagePicker _picker = ImagePicker();

  // await _picker.getImage(source: ImageSource.gallery).then((value) {
  //   if(value != null){
  //     imageFile = File(value.path);
  //     uploadImage();
  //   }
  // });
  }
  
  uploadImage()async{
    String fileName = Uuid().v1();
    Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": "",
        "type":"img",
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DbMethod().addPhoto(widget.chatRoomId, fileName, chatMessageMap);
    // DbMethod().addMessage(widget.chatRoomId, fileName);
    var ref = FirebaseStorage.instance.ref().child('images').child("");
    var upload = await ref.putFile(imageFile);

    String imageUrl = await upload.ref.getDownloadURL();
    print(imageUrl);
  }
  

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": imageFile,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DbMethod().addMessage(widget.chatRoomId, chatMessageMap);
    }
  }

  

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        // "like": isLike,
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DbMethod().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    
                    Expanded(
                        child: TextField(
                      controller: messageEditingController,
                      decoration: InputDecoration(
                        hintText: "Message ...",
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 5,
                    ),
                     GestureDetector(
                      onTap: () {
                        _getFromGallery();
                      },
                      child: Container(
                          height: 30,
                          width: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.image)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 30,
                          width: 20,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight),
                              borderRadius: BorderRadius.circular(40)),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.send)),
                    ),
                   
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTitle(dynamic message, bool sendByMe) {
    return message.runtimeType == String?
    GestureDetector(
      onDoubleTap: (){
        setState(() {
          // isLike != isLike;
        });
      },
          child: Container(
        padding: EdgeInsets.only(
            top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: isLike == true ? 
        Stack(
          children: [
            Container(
          margin:
              sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: sendByMe ? Colors.grey : Colors.blue,
          ),
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300)),
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.thumb_up, size: 15,)
        )
          ],
        )
        :Container(
          margin:
              sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            color: sendByMe ? Colors.grey : Colors.blue,
          ),
          child: Text(message,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300)),
        ),
      ),
    ):
    Container(
      height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width,
       padding: EdgeInsets.only(
            top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
        alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width/2,
  child: message != ""? Image.network(message): CircularProgressIndicator()
        )
    );
  }

  Widget chatRoomTitle(String userName, String chatRoomId) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
