import 'package:flutter/material.dart';

class LightModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final Color color;

  const LightModeButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
    this.color = const Color.fromARGB(255, 228, 36, 42), // Default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: color, // Outer color
            ),
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isSelected ? Colors.white : color,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: isSelected ? color : Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
