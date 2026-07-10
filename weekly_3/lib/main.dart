import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp()
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
            color: Colors.lightBlueAccent,
            child: Text("Container 1"),
            ),
            SizedBox(width: 30),
            Container(
            color: Colors.deepOrangeAccent,
            child: Text("Container 2"),
            ),
            Container(
            color: Colors.blueAccent,
            child: Text("Container 3") 
        ),
      ],
    )
  ),
),
);
}
}