import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget? child;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double width;
  final double height;
  final EdgeInsets? padding;

  const CustomCard({
    super.key,
    this.title,
    this.child,
    this.backgroundColor = const Color.fromARGB(255, 242, 242, 247),
    this.textColor = const Color(0xff673ab7),
    this.fontSize = 20,
    this.width = double.infinity,
    this.height = 140,
    this.padding = const EdgeInsets.all(16),
  }) : assert(
            title != null || child != null, 'Debe proporcionar title o child');

  @override
  Widget build(BuildContext context) {
    // Determinar el color de fondo efectivo
    Color effectiveBackgroundColor = backgroundColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Si es el color predeterminado y está en modo oscuro, cambiarlo
    if (backgroundColor == const Color.fromARGB(255, 242, 242, 247) &&
        isDarkMode) {
      effectiveBackgroundColor =
          const Color.fromARGB(255, 28, 28, 30); // Color oscuro
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: padding,
      child: child ?? _buildTitle(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    // Determinar el color del texto efectivo
    Color effectiveTextColor = textColor;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Si es el color predeterminado y está en modo oscuro, cambiarlo
    if (textColor == const Color(0xff673ab7) && isDarkMode) {
      effectiveTextColor = Colors.white;
    }

    return Text(
      title!,
      style: TextStyle(
          color: effectiveTextColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
