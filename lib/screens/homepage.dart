import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:theorderguy/Model/Slider_model.dart';
import 'package:theorderguy/Model/api_services.dart';
import 'package:theorderguy/Model/category_rest.dart';
import 'package:theorderguy/Model/favouriteList.dart';
import 'package:theorderguy/main.dart';
import 'package:theorderguy/screens/login.dart';
import 'package:theorderguy/screens/webview.dart';
import 'package:theorderguy/widgets/extendedFab.dart';

import '../constant.dart';
import '../widgets/alertdialog.dart';
import 'list.dart';

class BuilderScreen1 extends StatefulWidget {
  @override
  _BuilderScreenState createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen1>
    with TickerProviderStateMixin {
  TextEditingController name = new TextEditingController();
  var isLoading = false;
  var flag = false;
  final bool star = false;
  Timer timer;
  var cattitle = "";
  static var eyeonlist;
  var height_about_index = 0;
  static var errordis = null;

  int _currentPage = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;
  AnimationController _hideFabAnimation;

  checksponsore() {
    //eyeonlist = [];
    eyeonlist = reste.where((element) => element.sponsored == "1");
    if (reste.isNotEmpty) {
      if (double.parse(
              reste[0].distance.toString().split(" ").first.toString()) ==
          -1) {
        errordis =
            "Please enable the location permission to see the restaurants in 15 KM radius";
      } else {
        if (eyeonlist.isEmpty) {
          eyeonlist = reste.where((element) =>
              double.parse(
                  element.distance.toString().split(" ").first.toString()) <=
              radius);
        } else {
          height_about_index = eyeonlist.length;
          eyeonlist = (reste.where((element) =>
              double.parse(
                  element.distance.toString().split(" ").first.toString()) <=
              radius));
        }
        if (!eyeonlist.isEmpty) {
          height_about_index += eyeonlist.length;
        }
      }
    }
    print(height_about_index);
  }

  sortList(){
    List<restaurant> list = [];
    list.addAll(reste);
    for(int i=0;i<list.length-1;i++){
      for(int j=i+1;j<list.length;j++){
        if(list[i].sponsored=="0" && list[j].sponsored=="0"){
          if(double.parse(list[i].distance.split(" ").first.toString()) > double.parse(list[j].distance.split(" ").first.toString())){
            restaurant obj = list[j];
            list[j] = list[i];
            list[i]=obj;
          }
        }
      }
    }
for(var data in list){
  print(data.distance);
}
    reste.clear();
    reste.addAll(list);
  }

  @override
  void initState() {
    // TODO: implement initState
    checksponsore();
    sortList();

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

    timer = Timer.periodic(Duration(seconds: 8), (Timer timer) {
      if (_currentPage < sliderList.length) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage ?? 0,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
    cattitle = categoryList[0].category;

    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _hideFabAnimation.dispose();
    animationController.dispose();
    timer.cancel();
    _pageController.dispose();
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
    print("sdhhsdhshd" + (MediaQuery.of(context).size.width / 4.5).toString());

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
                          reste.sort((a, b) => a.name
                              .toString()
                              .toLowerCase()
                              .compareTo(b.name.toString().toLowerCase()));
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
                          reste.sort((a, b) => double.parse(
                                  a.distance.toString().split(" ").first)
                              .compareTo(double.parse(
                                  b.distance.toString().split(" ").first)));
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
          child: SingleChildScrollView(
            //key: UniqueKey(),
            child: Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: sliderList.length,
                        itemBuilder: (_, itemIndex) {
                          return InkWell(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 2,
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    width:
                                        MediaQuery.of(context).size.width * 2,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: CachedNetworkImage(
                                          fadeInCurve: Curves.easeIn,
                                          //fadeInDuration: Duration(seconds: 1),
                                          fadeOutCurve: Curves.easeOut,
                                          //fadeOutDuration: Duration(seconds: 1),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          imageUrl: "https://omenu.ca/" +
                                              sliderList[itemIndex].image,
                                          //imageUrl: "https://hacksmile.com/wp-content/uploads/2021/04/large-e0ad30e51c64444d7454-1.jpg",
                                          fit: BoxFit.cover,

                                          placeholder: (context, url) => Center(
                                            child: Container(
                                                // height: 80,
                                                // width: 80,
                                                child:
                                                    CircularProgressIndicator(
                                              value: 10.0,
                                            )),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 2.0),
                                    width:
                                        MediaQuery.of(context).size.width * 2,
                                    height: MediaQuery.of(context).size.height,
                                    decoration: sliderList[itemIndex].text !=
                                                null ||
                                            sliderList[itemIndex].browse_btn !=
                                                "0"
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                            //color: Colors.grey.withOpacity(0.5),

                                            gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Colors.black,
                                                Colors.transparent,
                                                Colors.transparent
                                              ],
                                            ),
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                            //color: Colors.grey.withOpacity(0.5),

                                            // gradient: LinearGradient(
                                            //   begin: Alignment.centerLeft,
                                            //   end: Alignment.centerRight,
                                            //   colors: [Colors.black, Colors.transparent,  Colors.transparent] ,
                                            // ),
                                          ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  sliderList[itemIndex].text ??
                                                      "",
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              22,
                                                      color: Colors.white
                                                          .withOpacity(1.0),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .8),
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                      ),
                                      sliderList[itemIndex].browse_btn != "0"
                                          ? InkWell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Align(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      // boxShadow: [
                                                      //   BoxShadow(
                                                      //     color: Colors.black.withOpacity(0.5),
                                                      //     spreadRadius: 1,
                                                      //     blurRadius: 10,
                                                      //     offset: Offset(0,1), // changes position of shadow
                                                      //   ),
                                                      // ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.orange,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Browse Now',
                                                        style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                22,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: .8),
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                ),
                                              ),
                                              onTap: () {
                                                if (sliderList[itemIndex]
                                                        .action !=
                                                    null) {
                                                  if (sliderList[itemIndex]
                                                      .action
                                                      .toString()
                                                      .contains("http")) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                WebViewExample(
                                                                    url: sliderList[
                                                                            itemIndex]
                                                                        .action)));
                                                  } else {
                                                    setState(() {
                                                      height_about_index = 0;
                                                      reste.clear();
                                                      isLoading = true;
                                                      cattitle = "";
                                                    });
                                                    var url =
                                                        "https://omenu.ca/actions.php?action=get_specific_category_feed&category_id=" +
                                                            sliderList[
                                                                    itemIndex]
                                                                .action
                                                                .toString();
                                                    print(url);
                                                    API
                                                        .getuseloc(url)
                                                        .then((value) {
                                                      isLoading = false;
                                                      checksponsore();

                                                      setState(() {});
                                                    });
                                                  }
                                                }
                                              },
                                            )
                                          : Container(),
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (sliderList[itemIndex].action != null) {
                                if (sliderList[itemIndex]
                                    .action
                                    .toString()
                                    .contains("http")) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          WebViewExample(
                                              url: sliderList[itemIndex]
                                                  .action)));
                                } else {
                                  setState(() {
                                    height_about_index = 0;
                                    reste.clear();
                                    isLoading = true;
                                    cattitle = "";
                                  });
                                  var url =
                                      "https://omenu.ca/actions.php?action=get_specific_category_feed&category_id=" +
                                          sliderList[itemIndex]
                                              .action
                                              .toString();
                                  print(url);
                                  API.getuseloc(url).then((value) {
                                    isLoading = false;
                                    checksponsore();

                                    setState(() {});
                                  });
                                }
                              }
                            },
                          );
                        }),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 4.9,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: categoryList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 5.0, bottom: 5),
                          child: Stack(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height / 4.9,
                                width: MediaQuery.of(context).size.width / 3.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration: Duration(seconds: 1),
                                      fadeOutCurve: Curves.easeOut,
                                      fadeOutDuration: Duration(seconds: 1),
                                      width: MediaQuery.of(context).size.width /
                                          1.07,
                                      imageUrl:
                                          categoryList[index].category_image,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Center(
                                        child: Container(
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator()),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    height_about_index = 0;
                                    cattitle = categoryList[index].category;
                                    reste.clear();
                                    isLoading = true;
                                  });
                                  if (cattitle == "See All") {
                                    reste = List.from(searchRest);
                                    checksponsore();

                                    setState(() {});
                                  } else {
                                    var url =
                                        "https://omenu.ca/actions.php?action=get_specific_category_feed&category_id=" +
                                            categoryList[index]
                                                .category_id
                                                .toString();
                                    print(url);
                                    API.getuseloc(url).then((value) {
                                      isLoading = false;
                                      checksponsore();

                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4.9,
                                  width:
                                      MediaQuery.of(context).size.width / 3.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white12,
                                          Colors.white12,
                                          Colors.black,
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Align(
                                    child: Text(
                                      categoryList[index].category,
                                      style: TextStyle(
                                          letterSpacing: 0.8,
                                          color: Colors.white,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              75,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    alignment: Alignment.bottomLeft,
                                  ),
                                  width: 120,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "ORDER FROM LOCAL RESTAURANT DIRECTLY",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 52,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        cattitle.toString(),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 50,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: Colors.grey[900],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: (height_about_index == 0
                        ? 250
                        : (double.parse(height_about_index.toString())) *
                            MediaQuery.of(context).size.height /
                            2.2),
                    child: errordis != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    errordis == null
                                        ? 'There are no nearest restaurants within a radius of 15KM for ' +
                                            cattitle.toString()
                                        : errordis,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      letterSpacing: 0.8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : reste.length != 0
                            ? ListView.builder(
                                //key: GlobalKey(),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: reste.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (_, index) {
                                  //flag = false;
                                  var a = reste.where((element) =>
                                      double.parse(element.distance
                                          .toString()
                                          .split(" ")
                                          .first
                                          .toString()) <=
                                      radius);
                                  a = reste.where((element) =>
                                      element.sponsored.toString() == "1");

                                  if (a.isEmpty && index == 0) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 60),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.5,
                                              child: Text(
                                                'There are no nearest restaurants within a radius of 15KM for ' +
                                                    cattitle.toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    letterSpacing: 0.8),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return checksponsoreindex(index, reste)
                                        ? InkWell(
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
                                                          BorderRadius.circular(
                                                              10),
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
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
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
                                                                    reste[index]
                                                                        .image,
                                                                fit:
                                                                    BoxFit.fill,
                                                                placeholder:
                                                                    (context,
                                                                            url) =>
                                                                        Center(
                                                                  child: Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                              )),
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
                                                                  top: 10,
                                                                  bottom: 0.0),
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
                                                                    child: Text(
                                                                      reste[index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          letterSpacing:
                                                                              0.8,
                                                                          fontSize: MediaQuery.of(context).size.width /
                                                                              28,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                      maxLines:
                                                                          1,
                                                                    ),
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        1.3,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (!MyApp
                                                                          .prefs
                                                                          .containsKey(
                                                                              "islogin")) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => loginpage()));
                                                                      } else {
                                                                        var a = favourite.where((element) =>
                                                                            element.id ==
                                                                            reste[index].id);
                                                                        if (a
                                                                            .isNotEmpty) {
                                                                          favourite.removeWhere((element) =>
                                                                              element.id ==
                                                                              reste[index].id);
                                                                          final String
                                                                              encodedData =
                                                                              CreditCardModel.encodeMusics(favourite);
                                                                          MyApp.prefs.setString(
                                                                              "favourite",
                                                                              encodedData);
                                                                        } else {
                                                                          favourite
                                                                              .add(CreditCardModel(
                                                                            delivery:
                                                                                reste[index].delivery,
                                                                            pickup:
                                                                                reste[index].pickup,
                                                                            desc:
                                                                                reste[index].desc,
                                                                            phone:
                                                                                reste[index].phone,
                                                                            url:
                                                                                reste[index].url,
                                                                            lng:
                                                                                reste[index].lng,
                                                                            lat:
                                                                                reste[index].lat,
                                                                            distance:
                                                                                reste[index].distance,
                                                                            address:
                                                                                reste[index].address,
                                                                            name:
                                                                                reste[index].name,
                                                                            id: reste[index].id,
                                                                            image:
                                                                                reste[index].image,
                                                                            sponsored:
                                                                                reste[index].sponsored,
                                                                          ));

                                                                          final String
                                                                              encodedData =
                                                                              CreditCardModel.encodeMusics(favourite);
                                                                          MyApp.prefs.setString(
                                                                              "favourite",
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
                                                                        color: favourite.where((element) => element.id == reste[index].id).isNotEmpty
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
                                                                      width: 3,
                                                                    ),
                                                                    reste[index].pickup ==
                                                                            "0"
                                                                        ? Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                20.0,
                                                                          )
                                                                        : reste[index].pickup ==
                                                                                "1"
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
                                                                      width: 5,
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
                                                                      width: 5,
                                                                    ),
                                                                    reste[index].delivery ==
                                                                            "0"
                                                                        ? Icon(
                                                                            Icons.close,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                20.0,
                                                                          )
                                                                        : reste[index].delivery ==
                                                                                "1"
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
                                                                        reste[index]
                                                                            .distance
                                                                            .toString(),
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        letterSpacing:
                                                                            0.8,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            MediaQuery.of(context).size.width /
                                                                                32),
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
                                                                child: Container(
                                                                    child: Text(
                                                                  reste[index]
                                                                      .address,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      letterSpacing:
                                                                          0.5,
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          MediaQuery.of(context).size.width /
                                                                              32),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )),
                                                                alignment: Alignment
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
                                                  // reste[index].sponsored == "1" ?
                                                  // Container(
                                                  //   height: MediaQuery.of(context).size.height / 4.5,
                                                  //   width: MediaQuery.of(context).size.width / 1.0,
                                                  //   decoration: BoxDecoration(
                                                  //     color: Colors.red,
                                                  //     borderRadius: BorderRadius.circular(10),
                                                  //     border: Border.all(color: Colors.grey),
                                                  //     gradient: LinearGradient(
                                                  //         begin: Alignment.topCenter,
                                                  //         end: Alignment.bottomCenter,
                                                  //         colors: [Colors.white12,Colors.white12,Colors.black,]
                                                  //     ),
                                                  //   ),
                                                  // ):
                                                  //     Container(),
                                                  Align(
                                                    child: InkWell(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Icon(
                                                          Icons.more_vert,
                                                          size: 30,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        alertdialog
                                                            .restdescdialog(
                                                          context: context,
                                                          name:
                                                              reste[index].name,
                                                          address: reste[index]
                                                              .address,
                                                          phone: reste[index]
                                                              .phone,
                                                          desc:
                                                              reste[index].desc,
                                                          weburl:
                                                              reste[index].url,
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
                                                      reste[index].sponsored ==
                                                              "1"
                                                          ? Stack(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child: Container(
                                                                      height: MediaQuery.of(context).size.height / 30,
                                                                      width: MediaQuery.of(context).size.height / 8,
                                                                      decoration: BoxDecoration(
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
                                                                            color:
                                                                                Colors.black.withOpacity(0.3),
                                                                            spreadRadius:
                                                                                2,
                                                                            blurRadius:
                                                                                7,
                                                                            offset:
                                                                                Offset(0, 0), // changes position of shadow
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      child: Center(
                                                                        child:
                                                                            Text(
                                                                          'Sponsored',
                                                                          style: sponsored.copyWith(
                                                                              fontSize: MediaQuery.of(context).size.height / 55,
                                                                              fontWeight: FontWeight.normal),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      )),
                                                                ),
                                                              ],
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
                                                              url: reste[index]
                                                                  .url)));
                                            },
                                          )
                                        : Container();
                                  }
                                },
                              )
                            : isLoading
                                ? Align(
                                    child: CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                      PrimaryColor,
                                    )),
                                    alignment: Alignment.center,
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: Text(
                                          errordis == null
                                              ? 'There are no nearest restaurants within a radius of 15KM for ' +
                                                  cattitle.toString()
                                              : errordis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            letterSpacing: 0.8,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
