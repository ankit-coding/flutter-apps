import 'package:capchat/services/database.dart';
import 'package:capchat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:capchat/helper/constants.dart';
import 'conversationScreen.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;




  Widget SearchList(){
    return searchSnapshot != null ?  ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return SearchTile(username: searchSnapshot.documents[index].data["name"] ,email: searchSnapshot.documents[index].data["email"]);
        }
    ) : Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }


  createChatRoomAndStartConversation(String username){

    print("${Constants.myName} here is my name");
    print(username);
      String chatRoomId = getChatRoomId(username, Constants.myName);
      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId : chatRoomId)
      ));
  }

  Widget SearchTile({String username, String email}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.indigo
            ),
            child: Text(username.substring(0,1).toUpperCase(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),),
          ),
          SizedBox(width: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),),
              Text(email, style: TextStyle(color: Colors.white54),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(username);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text("Message", style: TextStyle(color: Colors.white54),),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(50)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  SizedBox(width: 15,),
                  Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        style: TextStyle(color: Colors.white, fontSize: 16.5),
                        decoration: InputDecoration(
                            hintText: "Search Users ...",
                            hintStyle: TextStyle(
                                color: Colors.white54
                            ),
                            border: InputBorder.none
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.indigo
                        ),
                        child: Icon(Icons.search, color: Colors.white,size: 40,)),
                  )
                ],
              ),
            ),
            SearchList(),// searchList()QuerySnapshot
          ],
        ),
      ),

    );
  }
}


getChatRoomId(String a, String b){
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }
  else{
    return "$a\_$b";
  }
}
