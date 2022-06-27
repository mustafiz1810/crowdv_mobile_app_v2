import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
enum AnimationFrom{top,bottom}
ListAnimation({@required int index,@required Widget child,AnimationFrom animationFrom = AnimationFrom.top}){
  return AnimationConfiguration.staggeredList(
      position: index,
      duration: Duration(milliseconds: 375),
      child: SlideAnimation(
          verticalOffset: animationFrom== AnimationFrom.top ? -50.0 : 50,
          child: FadeInAnimation(
            child: child,
          )));
}