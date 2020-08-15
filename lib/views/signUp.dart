import 'package:flutter/material.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/services/database.dart';
import 'package:my_app/services/storage.dart';
import 'package:my_app/views/chatRoom.dart';
import 'package:my_app/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthMethods _authMethods = new AuthMethods();
  bool isLoading = false;
  DatabaseMethods _databaseMethods = new DatabaseMethods();

  signUp() {
    if (_formKey.currentState.validate()) {
      Map<String, String> userInfo = {
        "username": usernameController.text,
        "email": emailController.text
      };
      StorageMethods.saveUserEmailSharedPreference(emailController.text);
      StorageMethods.saveUserNameSharedPreference(usernameController.text);

      setState(() {
        isLoading = true;
      });
      _authMethods.SignUpWithEmailAndPassword(
              emailController.text, passwordController.text)
          .then((value) {
        _databaseMethods.uploadUserInfo(userInfo);
        StorageMethods.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      }).catchError((error) => print(error.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(context),
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height - 80,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                              controller: usernameController,
                              validator: (val) {
                                return val.isEmpty || val.length < 5
                                    ? 'Please enter a valid username'
                                    : null;
                              },
                              style: CustomTextStyle(),
                              decoration: textFieldInputDecoration('Username')),
                          TextFormField(
                              controller: emailController,
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                                        .hasMatch(val)
                                    ? null
                                    : 'Enter a valid email';
                              },
                              style: CustomTextStyle(),
                              decoration: textFieldInputDecoration('Email')),
                          TextFormField(
                              obscureText: true,
                              controller: passwordController,
                              validator: (val) {
                                return val.length < 6
                                    ? 'Enter a valid password'
                                    : null;
                              },
                              style: CustomTextStyle(),
                              decoration: textFieldInputDecoration('Password')),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.centerRight,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      child: Text('Forgot password', style: CustomTextStyle()),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        signUp();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0xff007EF4),
                            const Color(0xff2A75BC)
                          ]),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Sign up with Google',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account?",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Text(
                            "Sign in now",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80)
                  ],
                ),
              ),
            ),
    );
  }
}
