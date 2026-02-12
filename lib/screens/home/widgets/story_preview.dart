import 'package:flutter/material.dart';

class StoryPreview extends StatelessWidget {
  const StoryPreview({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: "story-pic$id",
              child: Image.asset(
                "assets/images/cat.jpg",
                fit: BoxFit.contain, // 🔥 fills screen
              ),
            ),
        
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black45,
                    Colors.transparent,
                    Colors.black54
                  ],
                ),
              ),
            ),
  
            SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        foregroundImage: AssetImage("assets/images/Hamza.png"),
                      ),
                      title: const Text(
                        "h.s_1605",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: const Text(
                        "• 2h ago",
                        style: TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },  
                        icon: Icon(Icons.close), 
                        color: Colors.white
                      ),
                    ),
                  ),

                  // bottom reply bar
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          suffixIcon: Icon(Icons.send)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )

    );
  }
}