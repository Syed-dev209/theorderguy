import 'package:dio/dio.dart';
import 'package:theorderguy/helperclasses/setCurrentLocation.dart';
import 'package:theorderguy/screens/list.dart';

import '../main.dart';
import 'Slider_model.dart';
import 'category_rest.dart';

class API {
  static var success = "false";
  static var apiresponse = "";

  static Future getuseloc(var url) async {
    success = "false";
    Dio dio = new Dio();
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      reste.clear();
      var data = response.data;
      //var records = data[];
      for (var i in data) {
        reste.add(restaurant(
          id: i['restaurant_id'],
          address: i['address'].toString().trim(),
          lat: i['lat'],
          lng: i['longi'],
          name: i['restaurant_name'],
          image: "https://omenu.ca/" + i['partner_image'],
          url: i["menu_link"],
          sponsored: i["sponsored"],
          desc: i["description"],
          phone: i["phone"],
          delivery: i["delivery"],
          pickup: i["pickup"],
        ));
      }

      if (setCurrentLocation.currentlocation != null) {
        for (int i = 0; i < reste.length; i++) {
          reste[i].distance = restaurant.calculateDistance(
            double.parse(reste[i].lat.toString()),
            double.parse(reste[i].lng),
            setCurrentLocation.currentlocation.latitude,
            setCurrentLocation.currentlocation.longitude,
            setCurrentLocation.currentlocation,
          );
        }

        // reste.sort((a, b) => double.parse(a.distance.toString().split(" ").first).compareTo(double.parse(b.distance.toString().split(" ").first)));

      } else {
        reste[0].distance = "-1 KM";
      }
    }

    success = 'true';
    return true;
  }

  static Future getrest(var url) async {
    success = "false";
    Dio dio = new Dio();
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var data = response.data;
      //var records = data[];
      reste.clear();
      for (var i in data) {
        reste.add(restaurant(
          id: i['restaurant_id'],
          address: i['address'].toString().trim(),
          lat: i['lat'],
          lng: i['longi'],
          name: i['restaurant_name'],
          image: "https://omenu.ca/" + i['partner_image'],
          url: i["menu_link"],
          sponsored: i["sponsored"],
          desc: i["description"],
          phone: i["phone"],
          delivery: i["delivery"],
          pickup: i["pickup"],
        ));
      }

      if (setCurrentLocation.currentlocation != null) {
        for (int i = 0; i < reste.length; i++) {
          reste[i].distance = restaurant.calculateDistance(
            double.parse(reste[i].lat.toString()),
            double.parse(reste[i].lng),
            setCurrentLocation.currentlocation.latitude,
            setCurrentLocation.currentlocation.longitude,
            setCurrentLocation.currentlocation,
          );
        }

        // reste.sort((a, b) => double.parse(a.distance.toString().split(" ").first).compareTo(double.parse(b.distance.toString().split(" ").first)));

      } else {
        reste[0].distance = "-1 KM";
      }

      final String encodedData = restaurant.encodeMusics(reste);
      MyApp.prefs.setString("rest_list", encodedData);
    }

    success = 'true';
    return true;
  }

  static Future getSlider(var url) async {
    success = "false";
    Dio dio = new Dio();
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      sliderList.clear();
      var data = response.data;
      //var records = data[];
      for (var i in data) {
        sliderList.add(Slider_model(
          image: i["image"],
          id: i["slide_id"],
          action: i["action"],
          text: i["text"],
          browse_btn: i["browse_btn"],
        ));
      }

      final String encodedData = Slider_model.encodeMusics(sliderList);
      MyApp.prefs.setString("slider_list", encodedData);
    }

    success = 'true';
    return true;
  }

  static Future getCategory(var url) async {
    success = "false";
    Dio dio = new Dio();
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      categoryList.clear();
      var data = response.data;
      categoryList.add(CategoryRest(
        category_id: "",
        category: "See All",
        category_image:
            "https://hacksmile.com/wp-content/uploads/2021/04/large-e0ad30e51c64444d7454-1.jpg",
      ));
      //var records = data[];+
      for (var i in data) {
        categoryList.add(CategoryRest(
          category_id: i["category_id"],
          category: i["category"],
          category_image: "https://omenu.ca/" + i['category_image'],
        ));
      }

      final String encodedData = CategoryRest.encodeMusics(categoryList);
      MyApp.prefs.setString("categoty_list", encodedData);
    }

    success = 'true';
    return true;
  }

  static Future Register(
      var name, var username, var email, var password) async {
    success = "false";
    var url = "https://omenu.ca/actions.php";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      'name': name.toString(),
      'username': username.toString(),
      'email': email.toString(),
      'password': password.toString(),
      'action': "register",
    });

    await dio
        .post(
      url,
      data: formData,
    )
        .then((response) {
      print(response);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data == "1") {
          MyApp.prefs.setBool("islogin", true);
          MyApp.prefs.setString("userEmail", email.toString());
          success = "true";
        } else {
          success = "error";
        }
        // if(data != []){
        //   for(var da in data){
        //     reste.add(restaurant(name: da['restaurant_name'],lat: da['lat'],lng: da['longi'],));
        //
        //   }
        // }

        // success=data['access_token'];
        // refresh=data['refresh_token'];
        // MyApp.sharedPreferences.setString('access_token', data['access_token'].toString());
        // MyApp.sharedPreferences.setString('refresh_token', data['refresh_token'].toString());
        // complete = "true";
        // print(data);
        //success = "true";
      } else {
        success = "error";
        print(response.statusCode);
      }
      //print(response.data);
    }).catchError((e) {
      success = "true";
      // print(e.error);
      // print(e);

      // if(e.error is SocketException){
      //   // success = "error";
      //   // print(e.error);
      //   // print(e);
      // }
      // else{
      //   // success = "error";
      // }
    });
  }

  static Future Login(var email, var password) async {
    success = "false";
    var url = "https://omenu.ca/actions.php";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      'user': email.toString(),
      'password': password.toString(),
      'action': "login",
    });

    await dio
        .post(
      url,
      data: formData,
    )
        .then((response) {
      print(response);
      if (response.statusCode == 200) {
        var data = response.data;
        if (data == "1") {
          MyApp.prefs.setBool("islogin", true);
          MyApp.prefs.setString("userEmail", email.toString());
          success = "true";
        } else {
          success = "error";
        }
        // if(data != []){
        //   for(var da in data){
        //     reste.add(restaurant(name: da['restaurant_name'],lat: da['lat'],lng: da['longi'],));
        //
        //   }
        // }

        // success=data['access_token'];
        // refresh=data['refresh_token'];
        // MyApp.sharedPreferences.setString('access_token', data['access_token'].toString());
        // MyApp.sharedPreferences.setString('refresh_token', data['refresh_token'].toString());
        // complete = "true";
        // print(data);
        //success = "true";
      } else {
        success = "error";
        print(response.statusCode);
      }
      //print(response.data);
    }).catchError((e) {
      success = "true";
      // print(e.error);
      // print(e);

      // if(e.error is SocketException){
      //   // success = "error";
      //   // print(e.error);
      //   // print(e);
      // }
      // else{
      //   // success = "error";
      // }
    });
  }

  static Future ReserPass(
    var email,
  ) async {
    success = "false";
    var url = "https://omenu.ca/actions.php";
    Dio dio = new Dio();
    FormData formData = new FormData.fromMap({
      'email': email.toString(),
      'action': "forgot_password",
    });

    await dio
        .post(
      url,
      data: formData,
    )
        .then((response) {
      print(response);
      if (response.statusCode == 200) {
        var data = response.data;
        MyApp.prefs.setString("userEmail", email.toString());
        success = "true";
        if (data == "1") {
          apiresponse = "Please check your email to recover your password";
        } else {
          apiresponse = "Your Email does not exist";
        }
      } else {
        success = "error";
        print(response.statusCode);
      }
      //print(response.data);
    }).catchError((e) {
      success = "true";
    });
  }
}
