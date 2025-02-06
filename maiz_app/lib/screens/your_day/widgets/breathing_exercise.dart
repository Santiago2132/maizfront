import 'package:flutter/material.dart';
import 'package:maiz_app/widgets/custom_card.dart';

class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<String> _phaseNotifier = ValueNotifier('Inhala');
  final Color _baseColor = const Color(0xff673ab7);
  final Color _accentColor = const Color(0xfffff5cc);
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating = false;
        });
        _controller.reset();
      }
    });

    _controller.addListener(() {
      final phaseValue = _controller.value;
      final currentPhase = _getPhase(phaseValue);
      _phaseNotifier.value = currentPhase;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _phaseNotifier.dispose();
    super.dispose();
  }

  String _getPhase(double value) {
    if (value < 0.333) return 'Inhala';
    if (value < 0.5) return 'Mantén';
    if (value < 0.833) return 'Exhala';
    return 'Mantén';
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return CustomCard(
      height: screenHeight * 0.22,
      backgroundColor: _baseColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (!_isAnimating)
            ElevatedButton(
              onPressed: _startAnimation,
              child: Text('Iniciar Ejercicio de Respiración'),
            ),
          if (_isAnimating)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: TweenSequence<double>([
                    TweenSequenceItem(
                        tween: Tween(begin: 1.0, end: 1.5), weight: 4),
                    TweenSequenceItem(
                        tween: Tween(begin: 1.5, end: 1.5), weight: 2),
                    TweenSequenceItem(
                        tween: Tween(begin: 1.5, end: 0.5), weight: 4),
                    TweenSequenceItem(
                        tween: Tween(begin: 0.5, end: 1.0), weight: 2),
                  ]).evaluate(_controller),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: ColorTween(
                        begin: _accentColor,
                        end: _accentColor,
                      ).evaluate(CurvedAnimation(
                        parent: _controller,
                        curve:
                            const Interval(0.0, 0.333, curve: Curves.easeInOut),
                      )),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          if (_isAnimating)
            ValueListenableBuilder(
              valueListenable: _phaseNotifier,
              builder: (context, phase, child) {
                return Column(
                  children: [
                    Text(
                      phase,
                      style: TextStyle(
                        color: _accentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      phase == 'Inhala'
                          ? Icons.arrow_upward
                          : phase == 'Exhala'
                              ? Icons.arrow_downward
                              : Icons.pause,
                      color: _accentColor,
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
