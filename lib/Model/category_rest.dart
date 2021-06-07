import 'dart:convert';

import '../main.dart';

List<CategoryRest> categoryList =
    CategoryRest.decodeMusics(MyApp.prefs.getString("categoty_list"));

class CategoryRest {
  var category_id, category, category_image;

  CategoryRest({
    this.category_id,
    this.category,
    this.category_image,
  });

  factory CategoryRest.fromJson(Map<String, dynamic> jsonData) {
    return CategoryRest(
      category_id: jsonData['category_id'],
      category: jsonData['category'],
      category_image: jsonData['category_image'],
    );
  }

  static Map<String, dynamic> toMap(CategoryRest vendors) => {
        'category_id': vendors.category_id,
        'category': vendors.category,
        'category_image': vendors.category_image,
      };

  static String encodeMusics(List<CategoryRest> cart) => json.encode(
        cart
            .map<Map<dynamic, dynamic>>((music) => CategoryRest.toMap(music))
            .toList(),
      );

  static List<CategoryRest> decodeMusics(String cart) {
    if (cart != null) {
      return (json.decode(cart) as List<dynamic>)
          .map<CategoryRest>((item) => CategoryRest.fromJson(item))
          .toList();
    } else {
      return new List();
    }
  }
}
