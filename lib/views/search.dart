import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helper/constant.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/views/conversation.dart';
import 'package:my_app/widgets/widgets.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = new TextEditingController();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot searchResult;

  searchUsers() {
    _databaseMethods.getUserByUsername(_searchController.text).then((val) {
      setState(() {
        searchResult = val;
      });
    });
  }

  Widget searchTile({String userName, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: <Widget>[
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Text(userName, style: CustomTextStyle()),
          Text(email, style: CustomTextStyle()),
        ]),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatRoomAndStartConversation(context, userName);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Message",
                style: CustomTextStyle(),
              )),
        )
      ]),
    );
  }

  Widget searchList() {
    return searchResult != null
        ? ListView.builder(
            itemCount: searchResult.documents.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return searchTile(
                  userName: searchResult.documents[index].data["username"],
                  email: searchResult.documents[index].data["email"]);
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search roomies',
          style: TextStyle(color: Colors.white, fontFamily: 'Nunito'),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0x54ffffff),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: _searchController,
                    style: CustomTextStyle(),
                    decoration: InputDecoration(
                        hintText: 'Search username...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                      onTap: () {
                        searchUsers();
                      },
                      child: Icon(Icons.search, color: Colors.white)),
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

// Create chat room and send user to conversion screen
createChatRoomAndStartConversation(BuildContext context, String username) {
  String myName = Constants.myName;
  print("$myName");
  if (username != myName) {
    List<String> users = [username, myName];
    String chatRoomId = getChatRoomId(username, myName);

    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatRoomId": chatRoomId
    };
    DatabaseMethods.createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)));
  } else {
    print("You cannot send message to yourself");
  }
}

String getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
