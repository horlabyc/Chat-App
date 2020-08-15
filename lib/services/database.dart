import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  uploadUserInfo(userInfo) {
    final _fireStore = Firestore.instance;
    _fireStore.collection('users').document().setData(userInfo).catchError((e) {
      print(e.toString());
    });
  }

  getUserByUsername(String username) async {
    final _fireStore = Firestore.instance;
    return await _fireStore
        .collection('users')
        .where("username", isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String userEmail) async {
    final _fireStore = Firestore.instance;
    return await _fireStore
        .collection('users')
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  static createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: username)
        .snapshots();
  }
}
