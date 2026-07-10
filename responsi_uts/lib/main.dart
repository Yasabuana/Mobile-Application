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

  @override
  State<Fitur> createState() => _FiturState();
}

class _FiturState extends State<Fitur> {

  int angkaAwal = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text('Yasabuana Athallahaufa Natawijaya',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        Text('2420506030',
        style: TextStyle(fontSize: 14)),
        ],
        )
      ),
        backgroundColor: Colors.blueGrey,
        body: Column(
          children: [
            Expanded(child: Container(
              width: double.infinity,
              color: Colors.blueGrey,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("image/crab_mangap.jpeg"),
              ),
              SizedBox(height: 15,),
              Text("Mr Crab Melongo Melihat Responsi UTS Kali Ini",
              style: TextStyle(
                fontSize: 30, 
                color: Colors.black,
                fontWeight: FontWeight.bold),
              ),
                  ],
                ))
            ),),

            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.deepOrange,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        SizedBox(height: 15),
                        ElevatedButton(onPressed: () {
                        setState(() {
                          angkaAwal = angkaAwal+5;
                      });
              },
              child: Text('+'),
              ),
                      ],) ,),
                    Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(child: Text('$angkaAwal',
                        style: TextStyle(fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        ),),),
                      ),
                      SizedBox(height: 10),
                    
                    Container(
                      padding: EdgeInsets.symmetric(
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(height: 15),
                          ElevatedButton(onPressed: () {
                          if (angkaAwal > 0)
                          setState (() {
                            angkaAwal--;
                        });
              },
              child: Text('-'),
              ),
                        ],
                      )
                      
                    )
                  ],
                ),

            ))
          ],) 
      );
  }
}
