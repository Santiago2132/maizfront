import 'dart:math';

class CalendarService {
  static final Map<DateTime, String> _emotionalRecords = {}; 

  static final Map<String, String> feelings = {
    'Deprimente': 'assets/icons/Depressed_icon.png',
    'Triste': 'assets/icons/sad_icon.png',
    'Regular': 'assets/icons/so_so_icon.png',
    'Feliz': 'assets/icons/Happy_icon.png',
    'Euforico': 'assets/icons/Euphoric_icon.png',
  };

  static Future<void> generateFakeData() async {
    final random = Random();
    final List<String> emotions = feelings.keys.toList(); 

    for (int i = 1; i <= 15; i++) {
      DateTime randomDate = DateTime(2025, 2, random.nextInt(28) + 1);
      _emotionalRecords[randomDate] = emotions[random.nextInt(emotions.length)];
    }
  }

  static Future<Map<DateTime, String>> getEmotionalRecords() async {
    if (_emotionalRecords.isEmpty) await generateFakeData(); 
    await Future.delayed(const Duration(milliseconds: 500)); 
    return _emotionalRecords;
  }

  static Future<void> saveEmotion(DateTime date, String emotion) async {
    _emotionalRecords[DateTime(date.year, date.month, date.day)] = emotion;
  }
}
