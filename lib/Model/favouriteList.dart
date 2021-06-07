import 'dart:convert';
import '../main.dart';

List<CreditCardModel> favourite = CreditCardModel.decodeMusics(MyApp.prefs.getString("favourite"));
class CreditCardModel {
  var id ,image, name, distance, address, lat, lng, url, sponsored, desc, phone, pickup, delivery;


  CreditCardModel({this.id, this.image, this.name, this.distance, this.address,this.lat, this.lng, this.url, this.sponsored,
    this.desc, this.phone,
    this.pickup, this.delivery,});


  factory CreditCardModel.fromJson(Map<String, dynamic> jsonData) {
    return CreditCardModel(
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

  static Map<String, dynamic> toMap(CreditCardModel vendors) => {

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

  static String encodeMusics(List<CreditCardModel> cart) => json.encode(
    cart
        .map<Map<dynamic, dynamic>>((music) => CreditCardModel.toMap(music))
        .toList(),
  );

  static List<CreditCardModel> decodeMusics(String cart){
    if(cart != null){
      return (json.decode(cart) as List<dynamic>)
          .map<CreditCardModel>((item) => CreditCardModel.fromJson(item))
          .toList();
    }
    else{
      return new List();
    }
  }

}