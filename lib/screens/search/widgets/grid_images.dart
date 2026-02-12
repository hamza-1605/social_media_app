import 'package:flutter/material.dart';

class GridImages extends StatelessWidget {
  const GridImages({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: 19,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage("assets/images/trending.png"),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}