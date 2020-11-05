import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUsername(String username) async {
    return await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments();
  }

  getUserByEmail(String email) async {
    return await Firestore.instance.collection("users").where("email", isEqualTo: email).getDocuments();
  }

  uploadUserInfo(userInfoMap) async {
    Firestore.instance.collection("users").add(userInfoMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("chatRoom").document(chatRoomId).setData(chatRoomMap);
  }
  addChatMessages(String chatRoomId, messageMap) async {
    Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }


  getChatMessages(String chatRoomId) async {
    return Firestore.instance.collection("chatRoom").document(chatRoomId).collection("chats").orderBy("time", descending: false).snapshots();
  }

  getChatRooms(String username) async {
    return Firestore.instance.collection("chatRoom").where("users", arrayContains: username).snapshots();
  }

}