import 'package:capchat/helper/authenticate.dart';
import 'package:capchat/helper/constants.dart';
import 'package:capchat/helper/helperFunction.dart';
import 'package:capchat/services/auth.dart';
import 'package:capchat/services/database.dart';
import 'package:capchat/views/conversationScreen.dart';
import 'package:capchat/views/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


class ChatRoomScreen extends StatefulWidget {
  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {
      databaseMethods.getChatRooms(Constants.myName).then((val){
        setState(() {
          chatRoomsStream = val;
        });
      });
    });
  }

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return chatRoomTile(snapshot.data.documents[index].data["chatRoomId"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""), snapshot.data.documents[index].data["chatRoomId"]);
          }
        ) : Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CapChat'),
        actions: [
          GestureDetector(
            onTap: (){
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.group_add_rounded),
        onPressed: (){
          HelperFunctions.getUserLoggedInSharedPreference().then((value){
            print(value);
            print("chatroom is he value");
          });
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => SearchScreen()
          ));
        },
      )
    );
  }
}

class chatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  chatRoomTile(this.username, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId: chatRoomId)
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white10,
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.indigo[400],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text("${username.substring(0,1).toUpperCase()}", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),),
            ),
            SizedBox(width: 18,),
            Text(username, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400, fontSize: 18),)
          ],
        ),
      ),
    );
  }
}
