import 'package:flutter/material.dart';

class RouteAnimation extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final String routeName;
  RouteAnimation({this.enterPage, this.exitPage, this.routeName})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => exitPage,
          transitionDuration: const Duration(milliseconds: 100),
          settings: RouteSettings(name: routeName),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              Stack(
            children: [
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: enterPage,
              ),
            ],
          ),
          //     FadeThroughTransition(
          //   animation: animation,
          //   secondaryAnimation: secondaryAnimation,
          //   child: enterPage,

          // ),
        );
}
