
import 'dart:math';

import 'package:clock_app/constants/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatefulWidget {
  final String header;
  final IconData icon;

  const CustomContainer({
    Key key,
    @required this.header,
    @required this.icon,
  }) : super(key: key);

  @override
  _CustomContainerState createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
 
  @override
  Widget build(BuildContext context) {
    return Material(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * .20,
          width: MediaQuery.of(context).size.width * .38,
          decoration: _semptomBoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(widget.icon,color: Colors.white,size: 25,),
                Text(widget.header,style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'avenir',
                    fontSize: 13,
                    fontWeight: FontWeight.w700),)
              ],
            ),
            ),
          ),

      ),
    );
  }

  BoxDecoration _semptomBoxDecoration() {
    var ccolor = Random();
    int ccclor = ccolor.nextInt(
        GradientTemplate.gradientTemplate.length - 1);
    var gradientColor =
        GradientTemplate.gradientTemplate[ccclor].colors;
    return BoxDecoration(
      gradient:LinearGradient(
        colors: gradientColor,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)],
    );
  }

}