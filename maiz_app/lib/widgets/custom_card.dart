import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double width;
  final double height;
  final EdgeInsets? padding; // Nuevo parámetro


  const CustomCard({
    super.key,
    this.title,
    this.child,
    this.backgroundColor = const Color(0xfffff5cc),
    this.textColor = const Color(0xff673ab7),
    this.fontSize = 20,
    this.width = double.infinity,
    this.height = 140,
    this.padding = const EdgeInsets.all(16),
  }) : assert(title != null || child != null, 
           'Debe proporcionar title o child');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: padding,
      child: child ?? _buildTitle(),
    );
  }

  Widget _buildTitle() {
    return Text(
      title!,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold
      ),
      textAlign: TextAlign.center,
    );
  }
}