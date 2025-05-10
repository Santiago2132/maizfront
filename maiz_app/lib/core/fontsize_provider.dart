import 'package:flutter/material.dart';

class FontSizeProvider extends ChangeNotifier {
 double _fontSize = 16.0; // Tamaño por defecto

  double get fontSize => _fontSize;

  void setFontSize(double newSize) {
    _fontSize = newSize;
    notifyListeners(); // Notifica a los widgets para redibujarse
  }

  void increaseFontSize() {
    if (_fontSize < 30) { // Límite máximo
      _fontSize += 2;
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (_fontSize > 12) { // Límite mínimo
      _fontSize -= 2;
      notifyListeners();
    }
  }
}
