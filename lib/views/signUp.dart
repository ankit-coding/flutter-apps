import 'package:capchat/helper/helperFunction.dart';
import 'package:capchat/services/auth.dart';
import 'package:capchat/services/database.dart';
import 'package:capchat/views/chatRoomScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  TextEditingController confirmPasswordTextEditingController = new TextEditingController();

  signUpUser(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val){
        if(val != null) {
          Map<String, String> userInfoMap = {
            "name": usernameTextEditingController.text,
            "email": emailTextEditingController.text
          };
          HelperFunctions.saveUserEmailSharedPreference(
              emailTextEditingController.text);
          HelperFunctions.saveUserNameSharedPreference(
              usernameTextEditingController.text);

          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);

          HelperFunctions.getUserLoggedInSharedPreference().then((value){
            print(value);
            print("signup is he value");
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
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator()),) : SingleChildScrollView(
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
                          return val.isEmpty || val.length < 2 ? "Enter Valid Username": null;
                        },
                        controller: usernameTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(color: Colors.white54),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.indigo)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54)
                            )
                        ),
                      ),
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
                        validator: (val){
                          return val.isEmpty || val.length < 8 ? "Your Password must be at least 8 characters.": null;
                        },
                        obscureText: true,
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
                      TextFormField(
                        validator: (val){
                          return val != passwordTextEditingController.text ? "Password mismatch": null;
                        },
                        obscureText: true,
                        controller: confirmPasswordTextEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Confirm Password",
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
                SizedBox(height: 20,),
                SignInButtonBuilder(
                  text: 'Sign Up with Email',
                  icon: Icons.email,
                  onPressed: () {
                    signUpUser();
                  },
                  backgroundColor: Colors.indigo,

                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10)
                  ),
                ),
                // SignInButton(
                //   Buttons.Google,
                //   text: "Sign up with Google",
                //   onPressed: () {},
                //   shape: new RoundedRectangleBorder(
                //       borderRadius: new BorderRadius.circular(10)
                //   ),
                // ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),),
                    SizedBox(width: 10,),
                    GestureDetector(onTap: (){
                      widget.toggleView();
                    },child: Container(padding : EdgeInsets.symmetric(vertical: 15),child: Text("Sign In Now", style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),))),
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
