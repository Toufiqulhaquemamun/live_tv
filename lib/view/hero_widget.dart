import 'package:flutter/material.dart';

typedef HeroBuilder = Widget Function(BuildContext context);

class HeroWidget extends StatelessWidget {
  final HeroBuilder heroBuilder;
  final Object heroTag;
  final double width;
  final VoidCallback onTap;

  const HeroWidget({
    Key key,
    @required HeroBuilder builder,
    @required this.heroTag,
    this.width = 100,
    this.onTap,
  })  : heroBuilder = builder,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            child: heroBuilder(context),
            onTap: onTap,
          ),
        ),
        flightShuttleBuilder:
            (flightContext, animation, direction, fromContext, toContext) {
          Widget flyingWidget = toContext.widget as Hero..child;

          if (direction == HeroFlightDirection.push) {
            flyingWidget = fromContext.widget as Hero..child;
          }

          return RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.ease))
                .animate(animation),
            child: flyingWidget,
          );
        },
      ),
    );
  }
}