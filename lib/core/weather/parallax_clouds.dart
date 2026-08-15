import 'package:flutter/material.dart';

class ParallaxClouds extends StatefulWidget {
  const ParallaxClouds({super.key});

  @override
  State<ParallaxClouds> createState() => _ParallaxCloudsState();
}

class _ParallaxCloudsState extends State<ParallaxClouds>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: [
            // BACK CLOUDS (slow)
            Positioned(
              left: w * controller.value,
              top: 80,
              child: Opacity(
                opacity: 0.2,
                child: Icon(Icons.cloud, size: 180, color: Colors.white),
              ),
            ),

            // FRONT CLOUDS (faster)
            Positioned(
              left: w - (w * controller.value * 1.2),
              top: 160,
              child: Opacity(
                opacity: 0.35,
                child: Icon(Icons.cloud, size: 120, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}