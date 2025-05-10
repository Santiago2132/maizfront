import 'package:flutter/material.dart';
import 'package:mAIz/core/fontsize_provider.dart';
import 'package:mAIz/widgets/custom_card.dart';
import 'package:provider/provider.dart';

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
        setState(() => _isAnimating = false);
        _controller.reset();
      }
    });

    _controller.addListener(() {
      _phaseNotifier.value = _getPhase(_controller.value);
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
    setState(() => _isAnimating = true);
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 600;

        return CustomCard(
          height: isSmallScreen
              ? 100
              : 134, // Altura para pantallas pequeñas y grandes
          backgroundColor: _baseColor,
          child: _isAnimating
              ? _buildAnimationContent(isSmallScreen)
              : _buildStartButton(),
        );
      },
    );
  }

  Widget _buildStartButton() {
    double fontSizeProvider = Provider.of<FontSizeProvider>(context).fontSize;

    return Center(
      child: ElevatedButton(
        onPressed: _startAnimation,
        child:  Text(
          'Iniciar Ejercicio de Respiración',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSizeProvider ),
        ),
      ),
    );
  }

  Widget _buildAnimationContent(bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Círculo animado con tamaño responsive
        SizedBox(
          height: isSmallScreen ? 80 : 120,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: TweenSequence<double>([
                  TweenSequenceItem(
                      tween: Tween(begin: 1.0, end: 1.23), weight: 4),
                  TweenSequenceItem(
                      tween: Tween(begin: 1.23, end: 1.23), weight: 2),
                  TweenSequenceItem(
                      tween: Tween(begin: 1.23, end: 0.5), weight: 4),
                  TweenSequenceItem(
                      tween: Tween(begin: 0.5, end: 0.8), weight: 2),
                ]).evaluate(_controller),
                child: Container(
                  width: isSmallScreen ? 40 : 60,
                  height: isSmallScreen ? 40 : 60,
                  decoration: BoxDecoration(
                    color: _accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        // Texto e icono
        ValueListenableBuilder(
          valueListenable: _phaseNotifier,
          builder: (context, phase, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  phase,
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: isSmallScreen ? 22 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  phase == 'Inhala'
                      ? Icons.arrow_upward
                      : phase == 'Exhala'
                          ? Icons.arrow_downward
                          : Icons.pause,
                  color: _accentColor,
                  size: isSmallScreen ? 28 : 34,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
