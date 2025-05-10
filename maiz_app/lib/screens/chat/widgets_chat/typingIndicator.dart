import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Pensando",
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(width: 6.0),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: (1 - ((_controller.value - (index * 0.2)).abs())).clamp(0.3, 1),
                          child: Transform.translate(
                            offset: Offset(0, _animation.value * (index % 2 == 0 ? 1 : -1)),
                            child: const Text(
                              ".",
                              style: TextStyle(fontSize: 22.0, color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
