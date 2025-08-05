import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ValueNotifier<Color> backgroundColorNotifier;

  const SettingsScreen({Key? key, required this.backgroundColorNotifier}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<Color> _colors = [
    Colors.white,
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.pink.shade100,
    Colors.amber.shade100,
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.backgroundColorNotifier.value;
  }

  void _onColorTap(Color color) {
    setState(() {
      _selectedColor = color;
      widget.backgroundColorNotifier.value = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Choose Home Screen Background Color:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _colors.map((color) {
            final bool isSelected = _selectedColor == color;

            return GestureDetector(
              onTap: () => _onColorTap(color),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}