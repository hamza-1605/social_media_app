import 'package:flutter/material.dart';

class RecentSearches extends StatelessWidget {
  const RecentSearches({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              spacing: 10,
              children: [
                Icon(Icons.history),
                Text("Hassan Ali"),
              ],
            ),
            Icon(Icons.close),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: 3,
    );
  }
}