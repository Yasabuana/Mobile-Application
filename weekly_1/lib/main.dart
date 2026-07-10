import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      
      appBar: AppBar(
      title: Text('Weekly 2', 
      style: TextStyle(color: Colors.yellowAccent )),
      backgroundColor: const Color.fromARGB(255, 127, 144, 228),
        ),
        body: Center(
        child: Image(image:AssetImage('image_senku/senku.jpg')),
        ),
      ),
    )
  );
}

