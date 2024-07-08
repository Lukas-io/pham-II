import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pham/view/product_item.dart';

import '../controller/controller.dart';
import '../model/product_model.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ProductController controller = ProductController();
  final List<String> loadingMessages = [
    'Hi there 👋',
    'Piecing things together',
    'Just a little bit longer',
    'one piece left...'
  ];
  int _currentIndex = 0;
  late Timer _timer;
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentIndex < loadingMessages.length - 1) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % loadingMessages.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductModel>>(
        future: controller.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            _animationController.reset();
            _animationController.forward();

            final offsetAnimation = Tween<Offset>(
              begin: Offset(0, 1),
              end: Offset(0, 0),
            ).animate(_animationController);

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color:
                        CupertinoColors.systemOrange.highContrastElevatedColor,
                  ),
                  SizedBox(height: 20),
                  SlideTransition(
                    position: offsetAnimation,
                    child: FadeTransition(
                      opacity: _animationController,
                      child: Text(
                        loadingMessages[_currentIndex],
                        key: ValueKey<int>(_currentIndex),
                        style: TextStyle(fontSize: 22, fontFamily: "Gelasio"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                  "Apologies, No available products today \n Come back tomorrow"),
            );
          } else {
            _timer.cancel();
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    leading: Icon(
                      CupertinoIcons.search,
                      size: 28.0,
                    ),
                    title: Column(
                      children: [
                        Text(
                          "Make Home",
                          style: TextStyle(
                            color: Color(0XFF999999),
                            fontFamily: "Gelasio",
                          ),
                        ),
                        Text(
                          "BEAUTIFUL",
                          style: TextStyle(
                              fontFamily: "Gelasio",
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          CupertinoIcons.shopping_cart,
                          size: 28.0,
                        ),
                      )
                    ],
                  ),
                  SliverPadding(
                    sliver: SliverAnimatedGrid(
                        itemBuilder: (context, index, animation) {
                          _animationController.reset();
                          _animationController.forward();
                          return FadeTransition(
                              opacity: animation,
                              child: ProductItem(
                                  productModel: snapshot.data![index]));
                        },
                        initialItemCount: snapshot.data!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 295.0,
                                mainAxisSpacing: 16.0,
                                crossAxisSpacing: 20.0)),
                    padding: const EdgeInsets.only(
                        right: 20.0, left: 20.0, bottom: 60.0, top: 20.0),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
