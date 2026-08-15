import 'dart:math';
import 'package:flutter/material.dart';

class WeatherEffects extends StatefulWidget {
  final String type; // rain, thunder

  const WeatherEffects({super.key, required this.type});

  @override
  State<WeatherEffects> createState() => _WeatherEffectsState();
}

class _WeatherEffectsState extends State<WeatherEffects>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  final random = Random();

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: List.generate(60, (i) {
            return Positioned(
              left: random.nextDouble() *
                  MediaQuery.of(context).size.width,
              top: (controller.value * 800 + i * 20) % 800,
              child: widget.type == "rain"
                  ? Container(
                      width: 2,
                      height: 10,
                      color: Colors.blueAccent.withOpacity(0.5),
                    )
                  : const Icon(Icons.flash_on,
                      color: Colors.yellow, size: 10),
            );
          }),
        );
      },
    );
  }
}