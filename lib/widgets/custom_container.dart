import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class CustomContainer extends StatelessWidget {
  final Widget? title;
  final String image;
  final List<Color> gradientColors;
  final Color textShadowColor;
  final Color boxShadowColor;
  final Color textColor;
  final double sizedBox;
  final double maxHeight;
  final double maxWidth;
  final Widget? child;

  final dynamic Function()? onTap;

  const CustomContainer({
    super.key,
    required this.image,
    required this.gradientColors,
    required this.textShadowColor,
    required this.boxShadowColor,
    required this.textColor,
    this.sizedBox = 50,
    this.onTap,
    this.maxHeight = 200,
    this.maxWidth = double.infinity,
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(children: [
          ZoomTapAnimation(
            onTap: onTap,
            child: Container(
              constraints:
              child != null ? BoxConstraints(minHeight: maxHeight, maxWidth: maxWidth) : BoxConstraints(maxHeight: maxHeight, maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: boxShadowColor, blurRadius: 20)],
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 80, maxWidth: 80),
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 10, right: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(100),
                                    bottomLeft: Radius.circular(90),
                                    topRight: Radius.circular(90),
                                    topLeft: Radius.circular(50)),
                              ),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 90, maxWidth: 90),
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 10, right: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(40)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: sizedBox,
                        ),
                        if(title != null) title!
                      ],
                    ),
                    if(child != null) const SizedBox(height: 20,),
                    if(child != null) child!
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
                constraints: const BoxConstraints(maxHeight: 80),
                child: FadeInImage(
                    placeholder: const NetworkImage('https://i.imgur.com/j9uCxbG.gif'), image: NetworkImage(image)),
          ),
          )]),
      );
  }
}
