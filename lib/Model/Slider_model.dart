import 'dart:convert';

import '../main.dart';

List<Slider_model> sliderList =
    Slider_model.decodeMusics(MyApp.prefs.getString("slider_list"));

class Slider_model {
  var id, image, text, action, browse_btn;

  Slider_model({
    this.id,
    this.image,
    this.text,
    this.action,
    this.browse_btn,
  });

  factory Slider_model.fromJson(Map<String, dynamic> jsonData) {
    return Slider_model(
      id: jsonData['id'],
      image: jsonData['image'],
      text: jsonData['text'],
      action: jsonData['action'],
      browse_btn: jsonData['browse_btn'],
    );
  }

  static Map<String, dynamic> toMap(Slider_model vendors) => {
        'id': vendors.id,
        'image': vendors.image,
        'text': vendors.text,
        'action': vendors.action,
        'browse_btn': vendors.browse_btn,
      };

  static String encodeMusics(List<Slider_model> cart) => json.encode(
        cart
            .map<Map<dynamic, dynamic>>((music) => Slider_model.toMap(music))
            .toList(),
      );

  static List<Slider_model> decodeMusics(String cart) {
    if (cart != null) {
      return (json.decode(cart) as List<dynamic>)
          .map<Slider_model>((item) => Slider_model.fromJson(item))
          .toList();
    } else {
      return new List();
    }
  }
}
