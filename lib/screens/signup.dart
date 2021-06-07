import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:theorderguy/Model/api_services.dart';
import 'package:theorderguy/constant.dart';
import 'package:theorderguy/widgets/bottomNavigation.dart';
import 'package:theorderguy/widgets/buttons.dart';
import 'package:theorderguy/widgets/inputfields.dart';

import 'homepage.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var name_C = new TextEditingController();
  var username_C = new TextEditingController();
  var email_C = new TextEditingController();
  var password_C = new TextEditingController();
  var visible = false;

  ///default form loading state
  bool _registerFormloading = false;

  ///form input firlds value
  String registerEmail = "";
  String registerPassward = "";

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

  _submitForm(){
    if(_formKey.currentState.validate()){


      Get.snackbar("Please wait!", "Sign-In.....", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5) );
      setState(() {
        visible = true;
      });

      API.Register(name_C.text, username_C.text, email_C.text, password_C.text)
          .whenComplete(() {
            setState(() {
              visible = false;
            });
            if(API.success != "error"){

              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => bottomNavbar()));
            }
            else{
              Get.snackbar("Error!", "This username or email is already taken.", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5));

            }
      }
      );

      print(password_C.text.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
          //resizeToAvoidBottomPadding: false,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height*1.1,
                width: MediaQuery.of(context).size.width,
                color: PrimaryColor,
                child: Stack(
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Image.asset('assets/images/logo.png', ),
                        ),
                        Text(
                          "Create new account ",style: logTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              new inputFields(
                                hintText: "Name",
                                controller: name_C,
                                textInputAction: TextInputAction.next,
                              ),
                              new inputFields(
                                hintText: "Username",
                                focusNode: _passwardFocusNode,
                                controller: username_C,
                                //isPasswardField: true,
                              ),
                              new inputFields(
                                hintText: "Email",
                                controller: email_C,
                                textInputAction: TextInputAction.next,
                                isEmailField: true,
                              ),
                              new inputFields(
                                hintText: "Password",
                                controller: password_C,
                                textInputAction: TextInputAction.next,
                                isPasswardField: true,
                              ),

                              button(
                                text: "Register",
                                onPressed: () {
                                  _submitForm();
                                },
                                isloading: _registerFormloading,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),

                        // Spacer(),
                        button(
                          text: "Back to login",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          outlinebtn: true,
                        ),
                        //SizedBox(height: 35,)

                      ],
                    ),
                    Visibility(
                      visible: visible,
                        child: Center(child: new CircularProgressIndicator(backgroundColor: Colors.white,strokeWidth: 10,))),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

