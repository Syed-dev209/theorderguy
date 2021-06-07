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

class Favrouit extends StatefulWidget {
  @override
  _FavrouitState createState() => _FavrouitState();
}

class _FavrouitState extends State<Favrouit> with TickerProviderStateMixin {
  List<CreditCardModel> searchfavourite = [];
  TextEditingController name = new TextEditingController();

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;
  ScrollController _hideButtonController;
  AnimationController _hideFabAnimation;

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

    searchfavourite.addAll(favourite);
    name.addListener(() {
      _filter(name.text);
    });

    _hideButtonController = new ScrollController();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
  }

  _filter(var text) {
    searchfavourite.clear();
    favourite.forEach((resDetail) {
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
        searchfavourite.add(resDetail);
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

  @override
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
                          favourite.sort((a, b) => a.name
                              .toString()
                              .toLowerCase()
                              .compareTo(b.name.toString().toLowerCase()));

                          searchfavourite = List.from(favourite);
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
                          favourite.sort((a, b) => double.parse(
                                  a.distance.toString().split(" ").first)
                              .compareTo(double.parse(
                                  b.distance.toString().split(" ").first)));
                          searchfavourite = List.from(favourite);
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
        body: SafeArea(
          child: Container(
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Container(
                color: Colors.grey[300],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Favourite",
                        style: logTextStyleblack,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 14,
                      width: MediaQuery.of(context).size.width / 1.07,
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
                    SizedBox(
                      height: 10,
                    ),
                    new Expanded(
                      child: searchfavourite.length != 0
                          ? ListView.builder(
                              itemCount: searchfavourite.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (_, index) {
                                return InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: Colors.grey),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4.5,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    10.0)),
                                                    child: CachedNetworkImage(
                                                      fadeInCurve:
                                                          Curves.easeIn,
                                                      fadeInDuration:
                                                          Duration(seconds: 1),
                                                      fadeOutCurve:
                                                          Curves.easeOut,
                                                      fadeOutDuration:
                                                          Duration(seconds: 1),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.07,
                                                      imageUrl:
                                                          searchfavourite[index]
                                                              .image,
                                                      fit: BoxFit.fill,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            child:
                                                                CircularProgressIndicator()),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )

                                                    // Image.network(
                                                    //   reste[index].image,
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
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 15,
                                                    bottom: 8.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            searchfavourite[
                                                                    index]
                                                                .name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    0.8,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 1,
                                                          ),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.3,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            if (!MyApp.prefs
                                                                .containsKey(
                                                                    "islogin")) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              loginpage()));
                                                            } else {
                                                              favourite.removeWhere(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      searchfavourite[
                                                                              index]
                                                                          .id);
                                                              final String
                                                                  encodedData =
                                                                  CreditCardModel
                                                                      .encodeMusics(
                                                                          favourite);
                                                              MyApp.prefs.setString(
                                                                  "favourite",
                                                                  encodedData);
                                                              setState(() {
                                                                searchfavourite =
                                                                    favourite;
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            child: Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.yellow,
                                                              size: 35.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Pick-up',
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    32,
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(
                                                            width: 3,
                                                          ),
                                                          searchfavourite[index]
                                                                      .pickup ==
                                                                  "0"
                                                              ? Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 20.0,
                                                                )
                                                              : searchfavourite[
                                                                              index]
                                                                          .pickup ==
                                                                      "1"
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .green,
                                                                      size:
                                                                          20.0,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            'Delivery',
                                                            style: TextStyle(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    32,
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors
                                                                    .black),
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          searchfavourite[index]
                                                                      .delivery ==
                                                                  "0"
                                                              ? Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 20.0,
                                                                )
                                                              : searchfavourite[
                                                                              index]
                                                                          .delivery ==
                                                                      "1"
                                                                  ? Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .green,
                                                                      size:
                                                                          20.0,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .red,
                                                                      size:
                                                                          20.0,
                                                                    ),
                                                        ],
                                                      ),
                                                    ),
                                                    //Spacer(),

                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            child: Text(
                                                          "Distance: " +
                                                              searchfavourite[
                                                                      index]
                                                                  .distance,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              letterSpacing:
                                                                  0.8,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  32),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Align(
                                                      child: Container(
                                                          child: Text(
                                                        searchfavourite[index]
                                                            .address,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            letterSpacing: 0.5,
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                28),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),

                                                    // InkWell(
                                                    //   onTap: () {
                                                    //     // Navigator.of(context).push(
                                                    //     //     MaterialPageRoute(
                                                    //     //         builder: (BuildContext context) =>
                                                    //     //             WebViewExample(
                                                    //     //                 url: searchfavourite[index].url)));
                                                    //     //WebView1(url: restaurant.rest[index].url)));
                                                    //   },
                                                    //   child: Align(
                                                    //     alignment:
                                                    //     Alignment.bottomCenter,
                                                    //     child: Container(
                                                    //       height: 45,
                                                    //       width:
                                                    //       MediaQuery.of(context)
                                                    //           .size
                                                    //           .width /
                                                    //           1.28,
                                                    //       decoration: BoxDecoration(
                                                    //         // boxShadow: [
                                                    //         //   BoxShadow(
                                                    //         //     color: Colors.black.withOpacity(0.5),
                                                    //         //     spreadRadius: 1,
                                                    //         //     blurRadius: 10,
                                                    //         //     offset: Offset(0,1), // changes position of shadow
                                                    //         //   ),
                                                    //         // ],
                                                    //         borderRadius:
                                                    //         BorderRadius.circular(
                                                    //             5),
                                                    //         color: PrimaryColor,
                                                    //       ),
                                                    //       child: Row(
                                                    //         children: [
                                                    //           Spacer(),
                                                    //           Text(
                                                    //             'Order Online Now',
                                                    //             style: TextStyle(
                                                    //                 fontSize: MediaQuery.of(
                                                    //                     context)
                                                    //                     .size
                                                    //                     .width /
                                                    //                     20,
                                                    //                 color:
                                                    //                 Colors.white,
                                                    //                 letterSpacing:
                                                    //                 .5),
                                                    //             maxLines: 1,
                                                    //           ),
                                                    //           Spacer(),
                                                    //           CircleAvatar(
                                                    //             radius: MediaQuery.of(
                                                    //                 context)
                                                    //                 .size
                                                    //                 .width /
                                                    //                 21,
                                                    //             backgroundColor:
                                                    //             Colors.white,
                                                    //             child: Center(
                                                    //               child: Padding(
                                                    //                 padding:
                                                    //                 const EdgeInsets
                                                    //                     .all(4.0),
                                                    //                 child: Icon(
                                                    //                   Icons
                                                    //                       .fastfood_outlined,
                                                    //                   size: 20,
                                                    //                   color: PrimaryColor,
                                                    //                 ),
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //           SizedBox(
                                                    //             width: 10,
                                                    //           )
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // SizedBox(
                                                    //   height: 10,
                                                    // )
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
                                              alertdialog.restdescdialog(
                                                context: context,
                                                name: reste[index].name,
                                                address: searchfavourite[index]
                                                    .address,
                                                phone: searchfavourite[index]
                                                    .phone,
                                                desc:
                                                    searchfavourite[index].desc,
                                                weburl:
                                                    searchfavourite[index].url,
                                              );
                                            },
                                          ),
                                          alignment: Alignment.topRight,
                                        ),
                                        // Row(
                                        //   children: [
                                        //     Spacer(),
                                        //     Padding(
                                        //       padding:  EdgeInsets.only(
                                        //           top: MediaQuery.of(context).size.height/7, right: 30),
                                        //       child: Row(children: [
                                        //         Container(
                                        //           height: MediaQuery.of(context).size.height/8,
                                        //           width: MediaQuery.of(context).size.height/8,
                                        //           decoration: BoxDecoration(
                                        //             color: Colors.grey,
                                        //             borderRadius:
                                        //             BorderRadius.circular(5),
                                        //             boxShadow: [
                                        //               BoxShadow(
                                        //                 color:
                                        //                 Colors.white.withOpacity(0.2),
                                        //                 spreadRadius: 2,
                                        //                 blurRadius: 7,
                                        //                 offset: Offset(0,
                                        //                     0), // changes position of shadow
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ]),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                WebViewExample(
                                                    url: searchfavourite[index]
                                                        .url)));
                                  },
                                );
                              },
                            )
                          : Center(
                              child: Text(
                                'No favourite product found',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  letterSpacing: 0.8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
