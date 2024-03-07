import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int itemCount = 5;
  final Duration animationDuration = const Duration(milliseconds: 1500);
  final double radius = 40;

  final double itemHeight = 420;
  final double itemMaxWidth = 370;
  int selectedIndex = 0;
  var focusNode = FocusNode();
  List<String> imageList =
      List.generate(itemCount, (index) => 'images/banner0${index + 1}.png');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 190, 225, 233),
            Color.fromARGB(255, 222, 240, 243),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Positioned(
                  bottom: 20,
                  child: TextButton(
                      onPressed: () {
                        js.context.callMethod('open',
                            ['https://github.com/RezaKhajvand/AnimatedList']);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.person_4_outlined),
                          SizedBox(width: 4),
                          Text('GitHub'),
                        ],
                      ))),
              Center(
                child: KeyboardListener(
                  focusNode: focusNode,
                  autofocus: true,
                  onKeyEvent: (value) {
                    //only work in debug mode
                    // if (value.runtimeType.toString() == 'KeyDownEvent') {
                    //   if (value.physicalKey.debugName == 'Arrow Left' &&
                    //       selectedIndex > 0) {
                    //     setState(() => --selectedIndex);
                    //   }
                    //   if (value.physicalKey.debugName == 'Arrow Right' &&
                    //       selectedIndex < itemCount - 1) {
                    //     setState(() => ++selectedIndex);
                    //   }
                    // }
                  },
                  child: SizedBox(
                    height: itemHeight,
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          double cardWidth = 0;
                          int firstIndex = 0;
                          int lastIndex = itemCount - 1;
                          if (selectedIndex == firstIndex ||
                              selectedIndex == lastIndex) {
                            if (selectedIndex == index) {
                              cardWidth = itemMaxWidth;
                            } else if (index == selectedIndex - 1 ||
                                index == selectedIndex + 1) {
                              cardWidth = itemMaxWidth / 2;
                            } else {
                              cardWidth = itemMaxWidth / 6;
                            }
                          } else {
                            if (selectedIndex == index) {
                              cardWidth = itemMaxWidth;
                            } else if (index == selectedIndex - 1 ||
                                index == selectedIndex + 1) {
                              cardWidth = itemMaxWidth / 3;
                            } else {
                              cardWidth = itemMaxWidth / 6;
                            }
                          }

                          return AnimatedContainer(
                            width: cardWidth,
                            duration: animationDuration,
                            curve: const ElasticOutCurve(),
                            decoration: BoxDecoration(
                                border: selectedIndex == index
                                    ? Border.all(
                                        color: const Color.fromARGB(
                                            255, 66, 121, 64))
                                    : null,
                                borderRadius:
                                    BorderRadius.circular(radius + 5)),
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () =>
                                  setState(() => selectedIndex = index),
                              borderRadius: BorderRadius.circular(radius),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(radius),
                                child: Image.asset(
                                  imageList[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 20),
                        itemCount: itemCount),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class ElasticOutCurve extends Curve {
  const ElasticOutCurve([this.period = 0.4]);

  final double period;

  @override
  double transformInternal(double t) {
    final double s = period / 4.0;
    return math.pow(2.7, -10 * t) *
            math.sin((t - s) * (math.pi * 2.0) / period) +
        1.0;
  }
}
