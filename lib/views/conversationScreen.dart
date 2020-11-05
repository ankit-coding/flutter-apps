import 'package:capchat/helper/constants.dart';
import 'package:capchat/helper/helperFunction.dart';
import 'package:capchat/services/database.dart';
import 'package:capchat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen({this.chatRoomId});
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController messageTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatMessageStream;

  Widget ChatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.documents[index].data["message"],snapshot.data.documents[index].data["sender"]==Constants.myName);
          },
        ) : Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  sendMessage(){
    HelperFunctions.getUserLoggedInSharedPreference().then((value){
      print(value);
      print("send is he value");
    });
    if(messageTextEditingController.text.isNotEmpty){
      print(Constants.myName);
      Map<String, dynamic> messageMap = {
        "message" : messageTextEditingController.text,
        "sender" : Constants.myName,
        "time" : DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addChatMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    databaseMethods.getChatMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.indigo[300],
                    borderRadius: BorderRadius.circular(50)
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    SizedBox(width: 15,),
                    Expanded(
                        child: TextField(
                          controller: messageTextEditingController,
                          style: TextStyle(color: Colors.white, fontSize: 16.5),
                          decoration: InputDecoration(
                              hintText: "Type a message . . .",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                        // initiateSearch();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.indigo
                          ),
                          child: Icon(Icons.send, color: Colors.white,size: 30,)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 16 , right: isSendByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.indigo : Colors.white24,
          borderRadius: isSendByMe ? BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))
              :  BorderRadius.only(bottomRight: Radius.circular(30),topRight: Radius.circular(30), bottomLeft: Radius.circular(30))
        ),
        child: Text(message, style: TextStyle(color: Colors.white, fontSize: 18),),
      ),
    );
  }
}
