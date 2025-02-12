class BadgeService {
  // Este método simula la obtención de insignias para un usuario.
  List<Badge> getBadges() {
    return [
      Badge(name: 'Iniciado', imagePath: 'assets/badges/image.png'),
      Badge(name: 'Experto', imagePath: 'assets/badges/image.png'),
      Badge(name: 'Veterano', imagePath: 'assets/badges/image.png'),
    ];
  }
}


class Badge {
  final String name;
  final String imagePath;

  Badge({required this.name, required this.imagePath});
}
