import 'package:flutter/material.dart';

final List<Color> availableColors = [
  Colors.red,
  Colors.black,
  Colors.white,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange
];

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final Function selectColor;
  final List<Color> colors;
  const ColorPicker(
      {super.key,
      required this.selectedColor,
      required this.selectColor,
      this.colors = const [
        Colors.red,
        Colors.black,
        Colors.white,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange
      ]});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        height: 30,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            ...availableColors.map((color) => InkWell(
                onTap: () {
                  selectColor(color);
                },
                child: Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: selectedColor == color
                            ? Border.all(color: Colors.blue[300]!, width: 2)
                            : Border.all(color: Colors.grey[100]!, width: 2),
                        color: color,
                        borderRadius: BorderRadius.circular(30)))))
          ],
        ));
  }
}
