import 'dart:convert';
import '../config/constants.dart';

class ProductModel {
  final String name;
  final double price;
  final String imageUrl;
  final String? description;
  final double? rating;
  final int? reviews;
  final int? quantity;

  ProductModel({
    this.quantity,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
    this.rating,
    this.reviews,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // var descriptionJson = jsonDecode(json["description"]);
    return ProductModel(
      name: json["name"],
      price: json["current_price"][0]["USD"][0],
      imageUrl: "$kBaseApiUrl/images/${json['photos'][0]['url']}",
      // description: descriptionJson["description"],
      // rating: descriptionJson["ratings"],
      // reviews: descriptionJson["review"],
      // quantity: json["available_quantity"],
    );
  }
}
