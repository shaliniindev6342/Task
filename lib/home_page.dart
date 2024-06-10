import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'crud_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final user = FirebaseAuth.instance.currentUser;

signOut() async {
  await FirebaseAuth.instance.signOut();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Home Page',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              signOut();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.logout,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CrudPage()),
            );
          },
          child: Text('Crud Operation',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
