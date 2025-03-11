import 'package:flutter/material.dart';
import 'package:mAIz/screens/calendar/calendarMarkets.dart';

class EmotionMarker extends StatelessWidget {
  final DateTime date;
  final CalendarMarkers calendarMarkers;

  const EmotionMarker({Key? key, required this.date, required this.calendarMarkers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: -1,
  
      child: SizedBox(
        width: 20, 
        height: 20,
        child: calendarMarkers.buildMarker(context, date) ?? const SizedBox.shrink(),
      ),
    );
  }
}
