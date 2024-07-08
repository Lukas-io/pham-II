import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel productModel;

  // final Function<void> onClick;

  const ProductItem({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //       builder: (BuildContext context) =>
              //           ProductDetails(productModel: productModel)),
              // );
            },
            child: Container(
              height: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(productModel.imageUrl),
                    fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0XFF606060).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8.0)),
                height: 30.0,
                width: 30.0,
                child: const Icon(
                  CupertinoIcons.bag_fill,
                  size: 20.0,
                  color: CupertinoColors.white,
                ),
              ))
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
          child: Text(
            productModel.name,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
          ),
        ),
        Text(
          '\$ ${productModel.price}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        )
      ],
    );
  }
}
