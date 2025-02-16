class BadgeService {
  // Este método simula la obtención de insignias para un usuario.
  List<Badge> getBadges() {
    return [
      Badge(name: '3 días feliz', imagePath: 'assets/badges/3 DIAS FELIZ.png'),
      Badge(name: '100 registros', imagePath: 'assets/badges/100 REGISTROS.png'),
      Badge(name: 'Bienvenido', imagePath: 'assets/badges/BIENVENIDO A LA APP.png'),
      Badge(name: 'Semana Euforico', imagePath: 'assets/badges/UNA SEMANA EUFORICO.png'),

    ];
  }
}


class Badge {
  final String name;
  final String imagePath;

  Badge({required this.name, required this.imagePath});
}
