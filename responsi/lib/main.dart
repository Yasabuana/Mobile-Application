import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 @override
 Widget build(BuildContext context) {
  return MaterialApp(
    home: Fitur(),
  );
 }
}
class Fitur extends StatefulWidget {
  const Fitur({super.key});
}
  @override
  State<Fitur> createState() => _FiturState();

  class _FiturState extends State<Fitur> {

  int angkaAwal = 10;
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text("Yasabuana Athallahaufa Natawijaya  2420506030",
          style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: Colors.blue,
        ),
        body: Column(
          verticalDirection: VerticalDirection.down, 
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.black,
              child: 
               Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("image/crab_mangap.jpeg"),)],
            )
        ),
        Container(
          width: double.infinity,
          height: 426.5,
          color: Colors.deepOrange,
          child: Column(
            children: [
              Icon(Icons.add,
              color: Colors.blueAccent),
              ElevatedButton(onPressed: () {
                setState(() {
                  angkaAwal++;
                });
              },
              child: Text('Angka Saat Ini: $angkaAwal'),
              ),
              SizedBox(
                height: 20
              ),
              Icon(Icons.remove,
              color: Colors.blueAccent),
              ElevatedButton(onPressed: () {
                setState(() {
                  angkaAwal--;
                });})
            ],
          )
          ,
        )] 
      ))
      
        
          ),);

  }
}
