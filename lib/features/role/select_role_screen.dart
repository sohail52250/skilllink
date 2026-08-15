import 'package:flutter/material.dart';
import '../home/screen/home_screen.dart';

class SelectRoleScreen extends StatelessWidget {
  final Function(Locale)? onLocaleChange;

  const SelectRoleScreen({
    super.key,
    this.onLocaleChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SkillLink",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(
                      onLocaleChange: onLocaleChange,
                    ),
                  ),
                );
              },
              child: const Text("Enter Marketplace"),
            ),
          ],
        ),
      ),
    );
  }
}