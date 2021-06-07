import 'dart:convert';
import 'dart:math';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:theorderguy/helperclasses/setCurrentLocation.dart';

import '../main.dart';

ProgressDialog pr;
List<restaurant> reste =
    restaurant.decodeMusics(MyApp.prefs.getString("rest_list"));
List<restaurant> searchRest = [];

class restaurant {
  var id,
      image,
      name,
      distance,
      address,
      lat,
      lng,
      url,
      sponsored,
      phone,
      desc,
      pickup,
      delivery;

  restaurant({
    this.id,
    this.image,
    this.name,
    this.distance,
    this.address,
    this.lat,
    this.lng,
    this.url,
    this.sponsored,
    this.phone,
    this.desc,
    this.pickup,
    this.delivery,
  });

  factory restaurant.fromJson(Map<String, dynamic> jsonData) {
    return restaurant(
      id: jsonData['id'],
      image: jsonData['image'],
      name: jsonData['name'],
      distance: jsonData['distance'],
      address: jsonData['address'],
      lat: jsonData['lat'],
      lng: jsonData['lng'],
      url: jsonData['url'],
      sponsored: jsonData['sponsored'],
      desc: jsonData['desc'],
      phone: jsonData['phone'],
      pickup: jsonData['pickup'],
      delivery: jsonData['delivery'],
    );
  }

  static Map<String, dynamic> toMap(restaurant vendors) => {
        'id': vendors.id,
        'image': vendors.image,
        'name': vendors.name,
        'distance': vendors.distance,
        'address': vendors.address,
        'lat': vendors.lat,
        'lng': vendors.lng,
        'url': vendors.url,
        'sponsored': vendors.sponsored,
        'desc': vendors.desc,
        'phone': vendors.phone,
        'pickup': vendors.pickup,
        'delivery': vendors.delivery,
      };

  static String encodeMusics(List<restaurant> cart) => json.encode(
        cart
            .map<Map<dynamic, dynamic>>((music) => restaurant.toMap(music))
            .toList(),
      );

  static List<restaurant> decodeMusics(String cart) {
    if (cart != null) {
      return (json.decode(cart) as List<dynamic>)
          .map<restaurant>((item) => restaurant.fromJson(item))
          .toList();
    } else {
      return new List();
    }
  }

  static String calculateDistance(
      var lat1, var lon1, var lat2, var lon2, var position) {
    setCurrentLocation.currentlocation = position;
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1); // deg2rad below
    var dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    var d = R * c; // Distance in km
    //d=( d * 1000);
    //d = d * 1000;

    // var p = 0.017453292519943295;
    // var c = cos;
    // var a = 0.5 - c((lat2 - lat1) * p)/2 +
    //     c(lat1 * p) * c(lat2 * p) *
    //         (1 - c((lon2 - lon1) * p))/2;
    // var d =  12742 * asin(sqrt(a));

    return d.toStringAsFixed(1) + " KM";
  }

  static double deg2rad(double deg) {
    return deg * (pi / 180);
  }

  static double rad2deg(double rad) {
    return (rad * 180) / pi;
  }
}
