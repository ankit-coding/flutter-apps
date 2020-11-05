import 'package:capchat/helper/authenticate.dart';
import 'package:capchat/helper/helperFunction.dart';
import 'package:capchat/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  bool userLog = false;
  @override
  Widget build(BuildContext context) {

    HelperFunctions.getUserLoggedInSharedPreference().then((value){
      userLog = value;
    });

    return MaterialApp(
      title: 'CapChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white12,
        primarySwatch: Colors.indigo,
      ),
      home: userLog != null ? ChatRoomScreen() : Authenticate()
      );
  }
}
