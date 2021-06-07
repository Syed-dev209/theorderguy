
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theorderguy/Model/api_services.dart';
import 'package:theorderguy/screens/signup.dart';
import 'package:theorderguy/widgets/bottomNavigation.dart';
import 'package:theorderguy/widgets/buttons.dart';
import 'package:theorderguy/widgets/inputfields.dart';
import '../widgets/alertdialog.dart';


import '../constant.dart';
import 'homepage.dart';

class loginpage extends StatefulWidget {

  @override
  _loginpageState createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {

  ///for focus node
  FocusNode _passwardFocusNode;
  @override
  void initState() {
    _passwardFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwardFocusNode.dispose();
    super.dispose();
  }

  ///default form loading state
  bool _registerFormloading = false;

  ///form input firlds value
  String registerEmail = "";
  String registerPassward = "";

  var email_C = new TextEditingController();
  var password_C = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var visible = false;


   set({var boo}){
    if(boo != null) {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        visible = boo;
      });
    }
  }

  _submitForm(){
    if(_formKey.currentState.validate()){

      Get.snackbar("Please wait!", "Login.....", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5) );
      setState(() {
        visible = true;
      });

      API.Login(email_C.text, password_C.text)
          .whenComplete(() {
        setState(() {
          visible = false;
        });
        if(API.success != "error"){

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => bottomNavbar()));
        }
        else{
          Get.snackbar("Error!", "Incorrect Email and Password!.", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5));

        }
      }
      );

      print(email_C.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: PrimaryColor,
                  child: Stack(
                    children: [
                      Column(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          Text("The Order Guys",style: logTextStyle,),
                         // Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                inputFields(
                                  hintText: "Email",
                                  isEmailField: true,
                                  controller: email_C,
                                  textInputAction: TextInputAction.next,
                                ),
                                inputFields(
                                  hintText: "Passward",
                                  focusNode: _passwardFocusNode,
                                  isPasswardField: true,
                                  controller: password_C,
                                ),
                                button(
                                  text: "Login",
                                  onPressed: () {
                                    _submitForm();
                                  },
                                  isloading: _registerFormloading,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 25.0, right: 8),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.double,

                                  ),
                                ),
                              ),
                            ),
                            onTap: (){
                              alertdialog.forgetpassdilog(context: context, set: set);
                            },
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 80.0, right: 80),
                            child: Row(
                              children: [
                                buildDivider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                buildDivider(),
                              ],
                            ),
                          ),

                          SizedBox(height: 10,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: <Widget>[
                          //     SignInButton(
                          //       Buttons.Apple,
                          //       mini: true,
                          //       onPressed: () {
                          //         //  _showButtonPressDialog(context, 'LinkedIn (mini)');
                          //       },
                          //     ),
                          //     SignInButton(
                          //       Buttons.Tumblr,
                          //       mini: true,
                          //       onPressed: () {
                          //         // _showButtonPressDialog(context, 'Tumblr (mini)');
                          //       },
                          //     ),
                          //     SignInButton(
                          //       Buttons.Facebook,
                          //       mini: true,
                          //       onPressed: () {
                          //         //   _showButtonPressDialog(context, 'Facebook (mini)');
                          //       },
                          //     ),
                          //     SignInButtonBuilder(
                          //       icon: Icons.email,
                          //       text: "Ignored for mini button",
                          //       mini: true,
                          //       onPressed: () {
                          //         //   _showButtonPressDialog(context, 'Email (mini)');
                          //       },
                          //       backgroundColor: Colors.cyan,
                          //     ),
                          //   ],
                          // ),
                         // Spacer(),
                          button(
                            text: "Sign up",
                            onPressed: () {
                              //Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => register()));
                            },
                            outlinebtn: true,
                          ),
                        ],
                      ),
                      Visibility(
                          visible: visible,
                          child: Center(child: new CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 10,))),
                    ],
                  )
                ),
              ),
            ),
          )),
    );
  }
}

Expanded buildDivider() {
  return Expanded(
    child: Divider(
      thickness: 2.9,
      color: Color(0xFFD9D9D9),
      height: 1.0,
    ),
  );
}
