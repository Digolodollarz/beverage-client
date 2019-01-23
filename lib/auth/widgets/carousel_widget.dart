import 'package:flutter/material.dart';

class Carousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function({BuildContext context, T item}) itemBuilder;

  const Carousel({Key key, @required this.items, @required this.itemBuilder})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController controller;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    controller = new PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: 0.75,
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new Container(
          child: new PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: widget.items.length,
              controller: controller,
              itemBuilder: (context, index) => builder(index)),
        ),
      ),
    );
  }

  builder(int index) {
    final size = MediaQuery.of(context).size;
    return new AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * size.height * 0.85,
            width: Curves.easeOut.transform(value) * size.width,
            child: child,
          ),
        );
      },
      child: new Container(
        margin: const EdgeInsets.all(4.0),
//        color: index % 2 == 0 ? Colors.blue : Colors.red,
        child: widget.itemBuilder(
          context: context,
          item: widget.items[index],
        ),
      ),
    );
  }
}
