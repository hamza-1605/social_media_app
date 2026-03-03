import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_media_app/core/constants/app_colors.dart';
import 'package:social_media_app/screens/search/widgets/grid_posts.dart';
import 'package:social_media_app/screens/search/widgets/search_results.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController textController = TextEditingController();

  Timer? _debounce;
  String _searchText = "";

  @override
  void dispose() {
    textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchText = value.trim();
      });
    });
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
              onChanged: onSearchChanged,

              decoration: InputDecoration(
                hintText: "Search users by exact name/email",
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 0.2,
                    color: AppColors.middlewareGrey,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1,
                    color: AppColors.buttonBlue,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: _searchText.isNotEmpty
              ? SearchResults( text: _searchText )
              : GridPosts(),
          ),
          
        ],
      ),
    );
  }

}