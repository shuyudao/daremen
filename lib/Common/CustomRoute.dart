import 'package:flutter/material.dart';

//自定义动画组件
class CustomRoute extends PageRouteBuilder{
  final Widget widget;

  CustomRoute(this.widget)
  :super(
    // 设置过度时间
    transitionDuration:Duration(milliseconds: 600),
    // 构造器
    pageBuilder:(
      // 上下文和动画
      BuildContext context,
      Animation<double> animaton1,
      Animation<double> animaton2,
    ){
      return widget;
    },
    transitionsBuilder:(
      BuildContext context,
      Animation<double> animaton1,
      Animation<double> animaton2,
      Widget child,
    ){
      // 左右滑动动画效果
      return SlideTransition(
        position: Tween<Offset>(
          // 设置滑动的 X , Y 轴
          begin: Offset(2.0, 0.0),
          end: Offset(0.0,0.0)
        ).animate(CurvedAnimation(
          parent: animaton1,
          curve: Curves.fastOutSlowIn
        )),
        child: child,
      );
    }
  );
}