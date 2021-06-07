import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theorderguy/Model/Slider_model.dart';
import 'package:theorderguy/Model/api_services.dart';
import 'package:theorderguy/Model/category_rest.dart';
import 'package:theorderguy/widgets/bottomNavigation.dart';

import '../constant.dart';
import '../main.dart';
import '../screens/list.dart';

Position currentPosition;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  //Position _currentPosition;
  String _currentAddress;
  Geolocator geolocator;

  navigate() {
    //await Future.delayed(const Duration(milliseconds: 1), (){
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => bottomNavbar()));
    // });
  }

  initi() {
    // Timer(
    //     Duration(milliseconds: 1), (){
    navigate();
    //   },
    // );
  }

  _getCurrentLocation() {
    try {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        currentPosition = position;

        for (int i = 0; i < reste.length; i++) {
          reste[i].distance = restaurant.calculateDistance(
            double.parse(reste[i].lat.toString()),
            double.parse(reste[i].lng),
            currentPosition.latitude,
            currentPosition.longitude,
            currentPosition,
          );
        }

        searchRest.addAll(reste);
        final String encodedData = restaurant.encodeMusics(reste);
        MyApp.prefs.setString("rest_list", encodedData);
        initi();
      }).catchError((e) {
        print(e);
        reste[0].distance = "-1 KM";
        // for (int i = 0; i < reste.length; i++) {
        //   reste[i].distance = "-1 KM";
        //
        // }
        searchRest.addAll(reste);
        final String encodedData = restaurant.encodeMusics(reste);
        MyApp.prefs.setString("rest_list", encodedData);
        initi();
      });
    } catch (error) {
      reste[0].distance = "-1 KM";
      // for (int i = 0; i < reste.length; i++) {
      //   reste[i].distance = "-1 KM";
      //
      // }
      searchRest.addAll(reste);
      final String encodedData = restaurant.encodeMusics(reste);
      MyApp.prefs.setString("rest_list", encodedData);
      initi();
    }
  }

  check() async {
    await Future.delayed(const Duration(milliseconds: 1), () {
      if (MyApp.prefs != null) {
        if (!MyApp.prefs.containsKey("rest_list")) {
          API
              .getSlider(
                  "https://omenu.ca/actions.php?action=get_top_slider_feed")
              .then((value) {
            API
                .getCategory(
                    "https://omenu.ca/actions.php?action=get_category_feed")
                .then((value) {
              API
                  .getrest("https://omenu.ca/actions.php?action=get_res_feed")
                  .then((value) {
                _getCurrentLocation();
              });
            });
          });
        } else {
          sliderList =
              Slider_model.decodeMusics(MyApp.prefs.getString("slider_list"));
          categoryList =
              CategoryRest.decodeMusics(MyApp.prefs.getString("categoty_list"));
          reste = restaurant.decodeMusics(MyApp.prefs.getString("rest_list"));
          _getCurrentLocation();
        }
      } else {
        check();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    geolocator = Geolocator()..forceAndroidLocationManager;
    check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: PrimaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset('assets/images/logo.png'),
            ),
            Text(
              "The Order Guys",
              style: logTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                  Colors.white,
                )),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
        ),
      ),
    );
  }
}
//
// class splash extends StatefulWidget {
//   @override
//   _splashState createState() => _splashState();
// }
//
// class _splashState extends State<splash> {
//   @override
//   Widget build(BuildContext context) {
//     return SplashScreen(
//       seconds: 7,
//       navigateAfterSeconds:  loginpage(),
//
//       image: Image.asset('assets/images/logo.png'),
//       backgroundColor: PrimaryColor,
//       useLoader: false,
//       photoSize: 150.0,
//     );
//   }
// }
