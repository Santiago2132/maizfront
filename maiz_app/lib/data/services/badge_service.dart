class BadgeService {
  // Este método simula la obtención de insignias para un usuario.
  List<Badge> getBadges() {
    return [
      Badge(nombre: '3 días feliz', imagePath: 'assets/badges/3 DIAS FELIZ.png'),
      Badge(nombre: '100 registros', imagePath: 'assets/badges/100 REGISTROS.png'),
      Badge(nombre: 'Bienvenido', imagePath: 'assets/badges/Bienvenido.png'),
      Badge(nombre: 'Semana Euforico', imagePath: 'assets/badges/UNA SEMANA EUFORICO.png'),

    ];
  }
}


class Badge {
  final String nombre;
  final String imagePath;

  Badge({required this.nombre, required this.imagePath});
}
