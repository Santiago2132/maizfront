import 'package:flutter/material.dart';
class TermsAndConditionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text("Términos y Condiciones")),  
      content: SingleChildScrollView(
        child: Center( 
          child: Column(
            children: [
              Text("Estos son los términos y condiciones..."),
              // Añade el contenido 
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text("Cerrar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}