import 'package:flutter/material.dart';
import 'package:social_media_app/screens/search/widgets/grid_images.dart';
import 'package:social_media_app/screens/search/widgets/recent_searches.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),

      body: Column(
        spacing: 15,
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              onChanged: (value) => setState(() {}),

              decoration: InputDecoration(
                hintText: "Search users, posts...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: textController.text.isNotEmpty
              ? const RecentSearches()
              : const GridImages(),
          ),
          
        ],
      ),
    );
  }

}