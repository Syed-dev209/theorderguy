import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:theorderguy/Model/favouriteList.dart';
import 'package:theorderguy/screens/webview.dart';
import 'package:theorderguy/widgets/extendedFab.dart';

import '../constant.dart';
import '../main.dart';
import '../widgets/alertdialog.dart';
import 'list.dart';
import 'login.dart';

class searchPage extends StatefulWidget {
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> with TickerProviderStateMixin {
  @override
  TextEditingController name = new TextEditingController();
  var isLoading = false;
  List<restaurant> _searchResult = [];
  static var errordis = null;

  var _formKey = GlobalKey<FormState>();

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;
  ScrollController _hideButtonController;
  AnimationController _hideFabAnimation;

  check() {
    if (double.parse(_searchResult[0].distance.toString().split(" ").first.toString()) == -1)
    {
      errordis = "Please enable the location permission to see the restaurants in 15 KM radius";
    }
  }

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation =
        Tween(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });

    _searchResult.addAll(searchRest);
    check();
    name.addListener(() {
      _filter(name.text);
    });

    _hideButtonController = new ScrollController();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
  }

  _filter(var text) {
    _searchResult.clear();
    searchRest.forEach((resDetail) {
      if ((resDetail.address
              .toString()
              .toLowerCase()
              .startsWith(text.toString().toLowerCase()) ||
          resDetail.distance
              .toString()
              .toLowerCase()
              .startsWith(text.toString().toLowerCase()) ||
          resDetail.name
              .toString()
              .toLowerCase()
              .startsWith(text.toString().toLowerCase())))
        _searchResult.add(resDetail);
    });
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _hideFabAnimation.dispose();

    animationController.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;

          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scaffold(
          floatingActionButton: ScaleTransition(
            scale: _hideFabAnimation,
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Transform.translate(
                    offset: Offset(150, 200),
                    // offset: Offset.fromDirection(getRadiansFromDegree(270), degOneTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child: MyApp.prefs.containsKey("islogin")
                          ? CircularButton(
                              color: PrimaryColor,
                              width: 50,
                              height: 50,
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onClick: () {
                                alertdialog.dialog(context);

                                if (animationController.isCompleted) {
                                  animationController.reverse();
                                } else {
                                  animationController.forward();
                                }
                              },
                            )
                          : CircularButton(
                              color: PrimaryColor,
                              width: 50,
                              height: 50,
                              icon: Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => loginpage()));

                                if (animationController.isCompleted) {
                                  animationController.reverse();
                                } else {
                                  animationController.forward();
                                }
                              },
                            ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(90, 250),
                    // offset: Offset.fromDirection(getRadiansFromDegree(225), degOneTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.centerRight,
                      child:
                          // FloatingActionButton.extended(
                          //   backgroundColor: Colors.white,
                          //   onPressed: (){},
                          //   label: new Text("Sort A to Z", style: TextStyle(color: Colors.black),),
                          //   icon: Icon(
                          //     Icons.sort_by_alpha,
                          //     color: Colors.black,
                          //   ),
                          // )

                          CircularButton(
                        color: PrimaryColor,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.sort_by_alpha,
                          color: Colors.white,
                        ),
                        onClick: () {
                          setState(() {
                            searchRest.sort((a, b) => a.name
                                .toString()
                                .toLowerCase()
                                .compareTo(b.name.toString().toLowerCase()));
                            _searchResult = List.from(searchRest);
                          });

                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(90, 330),
                    // offset: Offset.fromDirection(getRadiansFromDegree(180), degOneTranslationAnimation.value * 100),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          getRadiansFromDegree(rotationAnimation.value))
                        ..scale(degOneTranslationAnimation.value),
                      alignment: Alignment.center,
                      child:
                          // FloatingActionButton.extended(
                          //   backgroundColor: Colors.white,
                          //   onPressed: (){},
                          //   label: new Text("Sort from Location", style: TextStyle(color: Colors.black),),
                          //   icon: Icon(
                          //     Icons.sort,
                          //     color: Colors.black,
                          //   ),
                          // )
                          CircularButton(
                        color: PrimaryColor,
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.sort,
                          color: Colors.white,
                        ),
                        onClick: () {
                          setState(() {
                            searchRest.sort((a, b) => double.parse(
                                    a.distance.toString().split(" ").first)
                                .compareTo(double.parse(
                                    b.distance.toString().split(" ").first)));
                            _searchResult = List.from(searchRest);
                          });
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    ),
                  ),
                  Transform(
                    transform: Matrix4.rotationZ(0),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 5.0, top: 310, left: 200, bottom: 40),
                      child: CircularButton(
                        color: PrimaryColor,
                        width: 60,
                        height: 60,
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onClick: () {
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SafeArea(
              child: Container(
                color: Colors.grey[300],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Search Restaurants",
                        style: logTextStyleblack,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 14,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 3),
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value.isEmpty || value.length < 3) {
                                return "length too short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(fontSize: 15),
                              hintText: 'Search',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                              // suffix: Icon(
                              //   Icons.arrow_forward,
                              //   color: Colors.black,
                              // ),
                              //contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    new Expanded(
                      child: errordis != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    errordis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : _searchResult.length != 0
                              ? ListView.builder(
                                  itemCount: _searchResult.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (_, index) {
                                    //flag = false;
                                    var a = _searchResult.where((element) =>
                                        double.parse(element.distance
                                            .toString()
                                            .split(" ")
                                            .first
                                            .toString()) <=
                                        radius);
                                    a = _searchResult.where((element) =>
                                        element.sponsored.toString() == "1");

                                    if (a.isEmpty && index == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 80),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            child: Text(
                                              'There are no nearest restaurants within a radius of 15KM!',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                letterSpacing: 0.8,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return checksponsoreindex(
                                              index, _searchResult)
                                          ?
                                          //double.parse(_searchResult[index].distance.toString().split(" ").first.toString()) <= radius ?
                                          InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10,
                                                    bottom: 10),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        // boxShadow: [
                                                        //   BoxShadow(
                                                        //     color: Colors.grey.withOpacity(0.5),
                                                        //     spreadRadius: 5,
                                                        //     blurRadius: 7,
                                                        //     offset: Offset(0,
                                                        //         3), // changes position of shadow
                                                        //   ),
                                                        // ],
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                4.5,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              // borderRadius: BorderRadius.only(
                                                              //   topLeft: Radius.circular(10),
                                                              //   topRight: Radius.circular(10),
                                                              // ),
                                                            ),
                                                            child: ClipRRect(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10.0)),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  fadeInCurve:
                                                                      Curves
                                                                          .easeIn,
                                                                  fadeInDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  fadeOutCurve:
                                                                      Curves
                                                                          .easeOut,
                                                                  fadeOutDuration:
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      1.07,
                                                                  imageUrl:
                                                                      _searchResult[
                                                                              index]
                                                                          .image,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                  placeholder:
                                                                      (context,
                                                                              url) =>
                                                                          Center(
                                                                    child: Container(
                                                                        height:
                                                                            50,
                                                                        width:
                                                                            50,
                                                                        child:
                                                                            CircularProgressIndicator()),
                                                                  ),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                )

                                                                // Image.network(
                                                                //   _searchResult[index].image,
                                                                //   fit: BoxFit.fill,
                                                                // ),
                                                                ),
                                                            // Column(
                                                            //   children: [
                                                            //
                                                            //   ],
                                                            // ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8.0,
                                                                    top: 15,
                                                                    bottom:
                                                                        8.0),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Container(
                                                                    child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        _searchResult[index]
                                                                            .name,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            letterSpacing:
                                                                                0.8,
                                                                            fontSize: MediaQuery.of(context).size.width /
                                                                                28,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.3,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        if (!MyApp
                                                                            .prefs
                                                                            .containsKey("islogin")) {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => loginpage()));
                                                                        } else {
                                                                          var a = favourite.where((element) =>
                                                                              element.id ==
                                                                              _searchResult[index].id);
                                                                          if (a
                                                                              .isNotEmpty) {
                                                                            favourite.removeWhere((element) =>
                                                                                element.id ==
                                                                                _searchResult[index].id);
                                                                            final String
                                                                                encodedData =
                                                                                CreditCardModel.encodeMusics(favourite);
                                                                            MyApp.prefs.setString("favourite",
                                                                                encodedData);
                                                                          } else {
                                                                            favourite.add(CreditCardModel(
                                                                              delivery: _searchResult[index].delivery,
                                                                              pickup: _searchResult[index].pickup,
                                                                              desc: _searchResult[index].desc,
                                                                              phone: _searchResult[index].phone,
                                                                              url: _searchResult[index].url,
                                                                              lng: _searchResult[index].lng,
                                                                              lat: _searchResult[index].lat,
                                                                              distance: _searchResult[index].distance,
                                                                              address: _searchResult[index].address,
                                                                              name: _searchResult[index].name,
                                                                              id: _searchResult[index].id,
                                                                              image: _searchResult[index].image,
                                                                              sponsored: _searchResult[index].sponsored,
                                                                            ));

                                                                            final String
                                                                                encodedData =
                                                                                CreditCardModel.encodeMusics(favourite);
                                                                            MyApp.prefs.setString("favourite",
                                                                                encodedData);
                                                                          }

                                                                          setState(
                                                                              () {});
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .star,
                                                                          color: favourite.where((element) => element.id == _searchResult[index].id).isNotEmpty
                                                                              ? Colors.yellow
                                                                              : Colors.grey,
                                                                          size:
                                                                              35.0,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                                //Spacer(),
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        'Pick-up',
                                                                        style: TextStyle(
                                                                            letterSpacing: 0.5,
                                                                            fontSize: MediaQuery.of(context).size.width / 32,
                                                                            //fontWeight: FontWeight.bold,
                                                                            color: Colors.black),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            3,
                                                                      ),
                                                                      _searchResult[index].pickup ==
                                                                              "0"
                                                                          ? Icon(
                                                                              Icons.close,
                                                                              color: Colors.red,
                                                                              size: 20.0,
                                                                            )
                                                                          : _searchResult[index].pickup == "1"
                                                                              ? Icon(
                                                                                  Icons.check,
                                                                                  color: Colors.green,
                                                                                  size: 20.0,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.red,
                                                                                  size: 20.0,
                                                                                ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        'Delivery',
                                                                        style: TextStyle(
                                                                            letterSpacing: 0.5,
                                                                            fontSize: MediaQuery.of(context).size.width / 32,
                                                                            //fontWeight: FontWeight.bold,
                                                                            color: Colors.black),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      _searchResult[index].delivery ==
                                                                              "0"
                                                                          ? Icon(
                                                                              Icons.close,
                                                                              color: Colors.red,
                                                                              size: 20.0,
                                                                            )
                                                                          : _searchResult[index].delivery == "1"
                                                                              ? Icon(
                                                                                  Icons.check,
                                                                                  color: Colors.green,
                                                                                  size: 20.0,
                                                                                )
                                                                              : Icon(
                                                                                  Icons.close,
                                                                                  color: Colors.red,
                                                                                  size: 20.0,
                                                                                ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                        child:
                                                                            Text(
                                                                      "Distance: " +
                                                                          _searchResult[index]
                                                                              .distance,
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              0.8,
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              MediaQuery.of(context).size.width / 32),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    )),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Align(
                                                                  child:
                                                                      Container(
                                                                          child:
                                                                              Text(
                                                                    _searchResult[
                                                                            index]
                                                                        .address,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        letterSpacing:
                                                                            0.5,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width /
                                                                                28),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )),
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Align(
                                                      child: InkWell(
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          size: 30,
                                                          color: Colors.black,
                                                        ),
                                                        onTap: () {
                                                          alertdialog
                                                              .restdescdialog(
                                                            context: context,
                                                            name: _searchResult[
                                                                    index]
                                                                .name,
                                                            address:
                                                                _searchResult[
                                                                        index]
                                                                    .address,
                                                            phone:
                                                                _searchResult[
                                                                        index]
                                                                    .phone,
                                                            desc: _searchResult[
                                                                    index]
                                                                .desc,
                                                            weburl:
                                                                _searchResult[
                                                                        index]
                                                                    .url,
                                                          );
                                                        },
                                                      ),
                                                      alignment:
                                                          Alignment.topRight,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              5.5,
                                                          left: 10),
                                                      child: Row(children: [
                                                        // Container(
                                                        //   height: MediaQuery.of(context).size.height/8,
                                                        //   width: MediaQuery.of(context).size.height/8,
                                                        //   decoration: BoxDecoration(
                                                        //     color: Colors.grey,
                                                        //     borderRadius:
                                                        //     BorderRadius.circular(5),
                                                        //     boxShadow: [
                                                        //       BoxShadow(
                                                        //         color:
                                                        //         Colors.white.withOpacity(0.2),
                                                        //         spreadRadius: 2,
                                                        //         blurRadius: 7,
                                                        //         offset: Offset(0,
                                                        //             0), // changes position of shadow
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        Spacer(),
                                                        _searchResult[index]
                                                                    .sponsored ==
                                                                "1"
                                                            ? Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10),
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            MediaQuery.of(context).size.height /
                                                                                30,
                                                                        width:
                                                                            MediaQuery.of(context).size.height /
                                                                                8,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white,
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              spreadRadius: 2,
                                                                              blurRadius: 7,
                                                                              offset: Offset(0, 0), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'Sponsored',
                                                                            style:
                                                                                sponsored.copyWith(fontSize: MediaQuery.of(context).size.height / 55, fontWeight: FontWeight.normal),
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                          ),
                                                                        )),
                                                              )
                                                            : Container(),
                                                      ]),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            WebViewExample(
                                                                url: _searchResult[
                                                                        index]
                                                                    .url)));
                                              },
                                            )
                                          : Container();
                                    }
                                  },
                                )
                              : Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text: 'no results found for ',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: name.text.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20))
                                        ]),
                                  ),
                                ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
