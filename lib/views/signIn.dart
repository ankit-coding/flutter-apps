import 'package:capchat/helper/helperFunction.dart';
import 'package:capchat/services/auth.dart';
import 'package:capchat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if (formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value){
        if(value != null){
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.getUserLoggedInSharedPreference().then((value){
            print(value);
            print("signin is he value");
          });
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoomScreen()
          ));
        }
      });
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                SizedBox(height: 150,),
                Text("CapChat", style: TextStyle(fontSize: 60, color: Colors.indigo, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),),
                SizedBox(height: 50,),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Invalid Email ID";
                        },
                        controller: emailTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.white54),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54)
                            )
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.isEmpty || val.length < 8 ? "Your Password must be at least 8 characters.": null;
                        },
                        controller: passwordTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.white54),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54)
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                // with custom text
                GestureDetector(
                  onTap: (){
                    if(emailTextEditingController.text == ""){
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: Text('Alert !!!', style: TextStyle(color: Colors.indigo),),
                            content: Text('Enter your email then press \n"forgot password"', style: TextStyle(fontWeight: FontWeight.w500),),
                            elevation: 24.0,
                            backgroundColor: Colors.indigo.shade200,
                            actions: <Widget>[
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                    else{
                    authMethods.resetPass(emailTextEditingController.text);
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          content: Text('Reset Password link is sent to your email', style: TextStyle(fontWeight: FontWeight.w500),),
                          elevation: 24.0,
                          backgroundColor: Colors.indigo.shade200,
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(dialogContext)
                                    .pop(); // Dismiss alert dialog
                              },
                            ),
                          ],
                        );
                        },
                      );
                    }
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      child: Text("Forgot Password ?", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SignInButtonBuilder(
                  text: 'Sign In with Email',
                  icon: Icons.email,
                  onPressed: () {
                    signIn();
                  },
                  backgroundColor: Colors.indigo,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10)
                  ),
                ),
                // SignInButton(
                //   Buttons.Google,
                //   text: "Sign In with Google",
                //   onPressed: () {},
                //   shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(10)
                //   ),
                // ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ?", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),),
                    SizedBox(width: 10,),
                    GestureDetector(onTap:(){
                      widget.toggleView();
                    },child: Container(padding : EdgeInsets.symmetric(vertical: 15),child: Text("Sign Up Now", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
