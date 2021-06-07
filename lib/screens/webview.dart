import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../constant.dart';




class WebViewExample extends StatefulWidget {

  var url;
  WebViewExample({this.url});

  @override
  _WebViewExampleState createState() => _WebViewExampleState(url: this.url);
}

class _WebViewExampleState extends State<WebViewExample> {

  var url;
  _WebViewExampleState({this.url});

 // InAppWebViewController webViewController;
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool isLoading=true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  Future<bool> _exitApp(BuildContext context, var _controller) async {
    _controller.then((_controller) async{
      if (await _controller.canGoBack()) {
        print("onwill goback");
        _controller.goBack();
        return Future.value(true);
      } else {
        //flutterWebviewPlugin.close();
        //exit(0);
        Navigator.pop(context);
        // Scaffold.of(context).showSnackBar(
        //   const SnackBar(content: Text("No back history item")),
        // );
        return Future.value(true);
      }
    });
    // return Future.value(false);

  }

  @override
  Widget build(BuildContext context) {

    // return Scaffold(
    //     body: SafeArea(
    //       child: WillPopScope(
    //       onWillPop: (){_exitApp( context, _controller.future);},
    //         child: Container(
    //           height: MediaQuery.of(context).size.height,
    //           width: MediaQuery.of(context).size.width,
    //           child: Stack(
    //             children: [
    //               Container(
    //                 height: MediaQuery.of(context).size.height,
    //                 width: MediaQuery.of(context).size.width,
    //                 child: WebView(
    //                   key: _key,
    //                   initialUrl: url,
    //                   javascriptMode: JavascriptMode.unrestricted,
    //                   onWebViewCreated: (WebViewController webViewController) {
    //                     _controller.complete(webViewController);
    //                   },
    //                   onProgress: (int progress) {
    //                     print("WebView is loading (progress : $progress%)");
    //                   },
    //                   javascriptChannels: <JavascriptChannel>{
    //                     _toasterJavascriptChannel(context),
    //                   },
    //                   onPageStarted: (String url) {
    //                     print('Page started loading: $url');
    //                   },
    //                   onPageFinished: (String url) {
    //                     print('Page finished loading: $url');
    //                     setState(() {
    //                       isLoading = false;
    //                     });
    //                   },
    //                   gestureNavigationEnabled: true,
    //                 ),
    //               ),
    //
    //               isLoading ? Center( child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),),)
    //                   : Container(),
    //             ],
    //           ),
    //           ),
    //       )
    //     )
    // );

    return WillPopScope(
      onWillPop: (){_exitApp( context, _controller.future);},
      child: SafeArea(
        child: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return  Stack(
              children: [
                Padding(padding: EdgeInsets.only(top: 45),
                  child:WebView(
                    key: _key,
                    initialUrl: url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    // onProgress: (int progress) {
                    // print("WebView is loading (progress : $progress%)");
                    // },
                    javascriptChannels: <JavascriptChannel>{
                      _toasterJavascriptChannel(context),
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                      setState(() {
                        isLoading = false;
                      });
                    },
                    gestureNavigationEnabled: true,
                  ),
                ),




                isLoading ? Center( child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(PrimaryColor,))): Container(),
                Container(
                  height: MediaQuery.of(context).size.height/15,
                //  color: Colors.transparent,
                  color: PrimaryColor,
                 // color: Colors.grey.withOpacity(0.5),
                  child:

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back,
                            size: MediaQuery.of(context).size.height/25,
                            color: Colors.white,),
                        ),
                        onTap: (){
                          _exitApp(context, _controller.future);
                        },
                      ),
                       Spacer(),
                       Center(child: Text("The Order Guys",style: TextStyle(fontSize: 24, color: Colors.white),)),
                   SizedBox(width: 30,),

                    Spacer(),
                    ],
                  ),
                ),

              ],
            );
          }),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}




















// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//
// class WebView extends StatefulWidget {
//   var url;
//
//   WebView({this.url});
//
//   @override
//   _WebViewState createState() => _WebViewState(url: this.url);
// }
//
// class _WebViewState extends State<WebView> {
//   FlutterWebviewPlugin flutterWebviewPlugin= FlutterWebviewPlugin();
//   //var url= "https://catering.ricebowldeluxe.com/";
//   InAppWebViewController _webViewController ;
//
//   var url;
//
//   _WebViewState({this.url});
//
//   @override
//   void initState() {
//     super.initState();
//     flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {});
//   }
//
//   Future<bool> _exitApp(BuildContext context) async {
//     if (await _webViewController.canGoBack()) {
//       print("onwill goback");
//       _webViewController.goBack();
//     } else {
//       //flutterWebviewPlugin.close();
//       Navigator.pop(context);
//       // Scaffold.of(context).showSnackBar(
//       //   const SnackBar(content: Text("No back history item")),
//       // );
//       return Future.value(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: WillPopScope(
//         onWillPop: () => _exitApp(context),
//         child:
//         WebviewScaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.black,
//             leading: Icon(Icons.arrow_back, color: Colors.white,),
//           ),
//
//           url: url,
//           withZoom: true,
//           hidden: true,
//           withJavascript: true,
//           appCacheEnabled: true,
//           ignoreSSLErrors: true,
//           scrollBar: false,
//         ),
//         // InAppWebView(
//         //     //initialFile: url,
//         //     //initialUrl: url,
//         //     initialFile: url,
//         //     initialOptions: InAppWebViewGroupOptions(
//         //       crossPlatform: InAppWebViewOptions(
//         //         mediaPlaybackRequiresUserGesture: false,
//         //         //debuggingEnabled: true,
//         //       ),
//         //     ),
//         //     onWebViewCreated: (InAppWebViewController controller) {
//         //       _webViewController = controller;
//         //     },
//         //
//         //     androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
//         //       return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
//         //     }
//         // ),
//
//
//       ),
//     );
//   }
// }
