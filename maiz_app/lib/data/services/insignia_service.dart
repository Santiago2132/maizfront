class BadgeService {
  // Este método simula la obtención de insignias para un usuario.
  List<Badge> getBadges() {
    return [
      Badge(name: 'Iniciado', imagePath: 'assets/badges/badge1.png'),
      Badge(name: 'Experto', imagePath: 'assets/badges/badge2.png'),
      Badge(name: 'Veterano', imagePath: 'assets/badges/badge3.png'),
    ];
  }
}

class Badge {
  final String name;
  final String imagePath;

  Badge({required this.name, required this.imagePath});
}
