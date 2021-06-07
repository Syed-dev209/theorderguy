import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theorderguy/screens/webview.dart';
import 'package:get/get.dart';
import '../constant.dart';
import '../main.dart';
import 'package:theorderguy/Model/api_services.dart';

class alertdialog {
   static dialog(var context){
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text("Logout"),
          content: new Text('Are You Sure You want to logout?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("Yes", style: TextStyle(color: Colors.black),),
              onPressed: (){
                MyApp.prefs.remove("islogin");
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text("No", style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }

  static restdescdialog({var context, var name, var desc, var address, var phone, var weburl}){
    return showDialog(
      barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text(name, style: TextStyle(fontSize: 20),),
          content: Card(
            color: Colors.transparent,
            elevation: 0.0,
            child: Center(
              child: Column(
                children: <Widget>[
                  Divider(color: Colors.black,),
                  Text(
                    "Address:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                  ),
                  SizedBox(height: 8,),
                  Text(
                    address,
                    style: TextStyle(fontSize: 14),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Address: ",
                  //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  //
                  //     ),
                  //     SizedBox(width: 5,),
                  //     Flexible(
                  //       child: Container(
                  //         child: Text(
                  //           address,
                  //           style: TextStyle(fontSize: 14),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 8,),
                  Text(
                    "Description:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),

                  ),
                  SizedBox(height: 8,),
                  Text(
                    desc,
                    style: TextStyle(fontSize: 14),
                  ),

                  SizedBox(height: 8,),

                  Text(
                    "Phone No: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    phone,
                    style: TextStyle(fontSize: 14),
                  ),


                  SizedBox(height: 8,),

                  InkWell(
                    onTap: () {

                      Navigator.pop(context);
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WebViewExample(
                                      url: weburl)));
                      // WebView1(url: restaurant.rest[index].url)));
                    },
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width/1.92,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(
                                5),
                            color: PrimaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'SEE MENU + ORDER',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(
                                        context)
                                        .size
                                        .width /
                                        25,
                                    color:
                                    Colors.white,
                                    letterSpacing:
                                    .5),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  static forgetpassdilog({var context, var set}){
    //TextEditingController _textFieldController = TextEditingController();
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: new Text("Forget Password!"),
          content: new Text(MyApp.prefs.containsKey("userEmail") ?
          'We\'ve sent the password recovery link to '+MyApp.prefs.getString("userEmail").toString():
              "Please Sign-Up First"
          ),
          actions: <Widget>[

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: CupertinoTextField(
            //     placeholder: "abc@gnail.com",
            //     clearButtonMode: OverlayVisibilityMode.editing,
            //   ),
            // ),

            CupertinoDialogAction(
              child: Text("Yes", style: TextStyle(color: Colors.black),),
              onPressed: (){
                // MyApp.prefs.remove("islogin");
                if(!MyApp.prefs.containsKey("userEmail")){
                  Navigator.pop(context);
                }
                else{
                  Navigator.pop(context);
                  Get.snackbar("Please wait!", "Sending.....", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5) );
                  set(boo: true);
                  // setState(() {
                  //   visible = true;
                  // });

                  API.ReserPass(MyApp.prefs.getString("userEmail").toString())
                      .then((value) {
                    Get.snackbar(API.apiresponse, "", snackStyle: SnackStyle.GROUNDED, backgroundColor: Colors.white70, colorText: Colors.black,duration: Duration(seconds: 5));
                    set(boo: false);
                  });
                }

              },
            ),
            CupertinoDialogAction(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }
}

