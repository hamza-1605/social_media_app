import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  const CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, 
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Comments" , style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700
            )),
      
            // Mock Comments
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(),
                    isThreeLine: true,
                    title: Text("ibbad_butt${index+1}"),
                    subtitle: Text("Actually to be honest honest honest honest honest honest, I don't think this app is going to be a success. Maybe couple of downloads here and there, but otherwise no chance."),
                    trailing: Column(
                      children: [
                        Icon(Icons.favorite_outline),
                        Text("23"),
                      ],
                    ),
                  );
                }, 
                separatorBuilder: (context, index) => SizedBox(height: 10.0), 
                itemCount: 13
              ),
            ),
            
            // Add a Comment textfield
            SafeArea(
              top: false,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(
                    top: BorderSide(color: Colors.black12, width: 1) 
                  )
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Add a comment...",
                          suffixIcon: Icon(Icons.send),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide( width: 0.5, color: Colors.black38 )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide( width: 1, color: Colors.blue ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide( width: 0.5, color: Colors.black38 ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}