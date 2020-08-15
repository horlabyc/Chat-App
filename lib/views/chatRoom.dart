import 'package:flutter/material.dart';
import 'package:my_app/helper/constant.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/storage.dart';
import 'package:my_app/views/authenticate.dart';
import 'package:my_app/views/conversation.dart';
import 'package:my_app/views/search.dart';
import 'package:my_app/widgets/widgets.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await StorageMethods.getUserNameSharedPreference();
    _databaseMethods.getChatRooms(Constants.myName).then((value) {
      print("$value");
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                      snapshot.data.documents[index].data["chatRoomId"]
                          .replaceAll("_", "")
                          .replaceAll(Constants.myName, ""),
                      snapshot.data.documents[index].data["chatRoomId"]);
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat room',
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _authMethods.SignOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Search()));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile(this.username, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        color: Colors.black38,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(children: [
          Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(40)),
              child: Text(username.substring(0, 1).toUpperCase(),
                  style: CustomTextStyle())),
          SizedBox(width: 10),
          Text(username, style: CustomTextStyle())
        ]),
      ),
    );
  }
}
