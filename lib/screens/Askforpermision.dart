import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Splash.dart';

class AskForPermission extends StatefulWidget {

  @override
  _AskForPermissionState createState() => _AskForPermissionState();
}
class _AskForPermissionState extends State<AskForPermission> {
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  void initState() {
    super.initState();
    _checkGps();
    // _gpsService();
  }
  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    setState(() async {
      if (result[permission] == PermissionStatus.granted){
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()));

      }
    });
    return false;
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted!=true) {
      requestLocationPermission();
    }
    debugPrint('requestContactsPermission $granted');
    return granted;
  }


  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        setState(() {
          _showMyDialog();
        });
        // showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text("Can't get gurrent location"),
        //         content:const Text('Please make sure you enable GPS and try again'),
        //         actions: <Widget>[
        //           FlatButton(child: Text('Ok'),
        //               onPressed: () {
        //                 final AndroidIntent intent = AndroidIntent(
        //                     action: 'android.settings.LOCATION_SOURCE_SETTINGS');
        //                 intent.launch();
        //                 Navigator.of(context, rootNavigator: true).pop();
        //                 _gpsService();
        //               })],
        //       );
        //     });
      }
    }else{
      reqalwawy();
      //requestLocationPermission();
    }
  }
  reqalwawy()async{
    final ph = PermissionHandler();
    final requested = await ph.requestPermissions([
      PermissionGroup.locationAlways,
      //PermissionGroup.locationWhenInUse
    ]);
    final alwaysGranted = requested[PermissionGroup.locationAlways] == PermissionStatus.granted;
    print(alwaysGranted.toString());
    if(alwaysGranted){
      setState((){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()));
      });
    }
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Can't get current location"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please make sure you enable GPS and try again'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok.!'),
              onPressed: () {
                final AndroidIntent intent = AndroidIntent(
                    action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                intent.launch();
                Navigator.of(context, rootNavigator: true).pop();
                //_gpsService();
                _checkGps();

              },
            ),
          ],
        );
      },
    );
  }

  // Future _gpsService() async {
  //   if (!(await Geolocator().isLocationServiceEnabled())) {
  //     _checkGps();
  //     return null;
  //   } else
  //     return true;
  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm Exit"),
                content: Text("Are you sure you want to exit?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("YES"),
                    onPressed: (){
                      SystemNavigator.pop();
                    },
                  ),
                  FlatButton(
                    child: Text("NO"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            }
        );
      },
      child: Scaffold(
//        appBar: AppBar(
//          title: Text('Ask for permisions'),
//          backgroundColor: Color.fromRGBO(119, 0, 0, 1),
//        ),
//        body: Center(
//            child: Column(
//              children: <Widget>[
//                Text("All Permission Granted"),
//              ],
//            ))
      ),
    );
  }
}