import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({super.key, required this.keyword});

  final String keyword;

  final List<Map<String, dynamic>> pageTypes = [
    {
      "keyword" : "connection",
      "errorMessage": "Check your Internet connection and try again.",   
      "imageLink": "https://media.istockphoto.com/id/804405616/vector/unplug.jpg?s=612x612&w=0&k=20&c=IwTieCGXxyzc1_bEmf2FMp9FxIP1eMoJ_qSupL7B5vg=", 
      "buttonMessage": "Try Again",   
      "icondata": Icons.replay_rounded
    },
    {
      "keyword" : "404",
      "errorMessage": "Sorry we couldn't find the page you're looking for.",   
      "imageLink": "https://img.freepik.com/premium-vector/illustration-search_757131-4203.jpg?semt=ais_hybrid&w=740&q=80", 
      "buttonMessage": "Go Back",   
      "icondata": Icons.arrow_back
    },
    {
      "keyword" : "error",
      "errorMessage": "Some unexpected error occured!",   
      "imageLink": "https://thumbs.dreamstime.com/b/error-d-people-upset-metaphor-43976249.jpg", 
      "buttonMessage": "Go Back",   
      "icondata": Icons.arrow_back
    },
  ];

  @override
  Widget build(BuildContext context) {
    
    final page = pageTypes.firstWhere(
      (e) => e["keyword"] == keyword,
      orElse: () => pageTypes[0],
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            spacing: 15.0,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network( page["imageLink"] , width: MediaQuery.of(context).size.width / 1.5, ),
              Text("Oh uh!", style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),),
              Text( page["errorMessage"] , textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Icon(page["icondata"], size: 25),
                    Text(page["buttonMessage"] , style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),),
                  ],
                )
              ),
            ],
          ),
        ),       
        
      )
    );
  }
}