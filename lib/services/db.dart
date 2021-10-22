import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DbMethod {
  getUserClientbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserClientbyEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: email)
        .get();
  }

  getListClient() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  updateUserProfile(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print("Failure" + e.toString());
    });
  }

  changeUserEmailProfile(emailMap) {
    FirebaseFirestore.instance.collection("users").doc().update(
        {'email': emailMap['email'], 'name': emailMap['name']}).catchError((e) {
      print("Failure" + e.toString());
    });

    // FirebaseFirestore.instance.collection("users").doc().set({'email':emailMap['email'], 'name':emailMap['name']}).catchError((e) {
    //   print("Failure" + e.toString());
    // });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc()
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<void> addPhoto(String chatRoomId, imageData, imageMap) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .doc(imageData)
        .set(imageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}



//WD56sTKUaDN4gOIQ6QYJ
